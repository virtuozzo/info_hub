require 'core/onapp/errors'

module OnApp
  module Models
    ## Abstract ActiveRecord class for all OnApp models to inherit from to use the OnApp database connection.
    ## All requests through this model will be logged using the default application logger.
    class Base < ActiveRecord::Base
      extend Utils::AR::Methods
      include Permissions::BaseModelMethods

      validate :check_fields_length

      self.default_timezone = :utc
      self.time_zone_aware_attributes = true

      self.abstract_class = true

      ## Automatically give any entries an identifier
      before_create :generate_identifier

      scope :allowed_for_reseller, ->    { scoped } #stub
      scope :by_user_group,        ->(*) { scoped } #stub
      scope :by_billing_plan,      ->(*) { scoped } #stub

      def to_s
        respond_to?(:label) ? label : super
      end

      def self.by_id(value)
        where(id: value)
      end

      def self.by_identifier(value)
        where(identifier: value)
      end

      def self.by_user(value)
        value = Array(value).collect! { |val| !val.nil? && val.respond_to?(:id) ? val.id : val }
        value << nil if value.empty?

        where(arel_table[:user_id].eq_any(value))
      end

      def self.omit(value)
        id = case value
             when self; value.id
             when Fixnum; value
             when ActiveRecord::Relation; value.pluck(:id)
             else raise ArgumentError, "Unsupported argument type: #{ value.class }"
             end
        id = Array.wrap(id)

        id.present? ? where(arel_table[:id].not_eq_all(id)) : scoped
      end

      def self.add_by_association_user_scope(association = :virtual_machine, klass = 'VirtualMachine')
        scope :by_user, ->(value) { joins(association).merge(klass.constantize.by_user(value)) }
      end

      def self.add_by_association_user_group_scope(association = :user, klass = 'User')
        scope :by_user_group, ->(user) { joins(association).merge(klass.constantize.by_user_group(user)) }
      end

      def self.add_by_billing_user_plan_scope(resource_name = self)
        scope :by_billing_plan, ->(user) {
          # TODO BILLING: maybe, throw an exception if resource_name is not appropriate
          # or move it back to models. Or find some more obvious way to avoid of code duplication
          where(id: ("Billing::User::Resource::#{ resource_name }".constantize.by_billing_plan(user.billing_plan).
                                                                              with_target.
                                                                              pluck(:target_id)))
        }
      end

      def self.add_by_association_billing_plan_scope(association, klass)
        scope :by_billing_plan, ->(user) { joins(association).merge(klass.constantize.by_billing_plan(user)) }
      end

      def self.desc(column = :id)
        order(Utils::AR.desc(self, column))
      end

      def self.acts_as(klass)
        klass_name = klass.name

        instance_eval %Q{
          def model_name
            #{ klass_name }.model_name
          end

          def i18n_scope
            #{ klass_name }.i18n_scope
          end
        }
      end

      def generate_identifier(skip_exist = false)
        return unless respond_to?(:identifier)
        return unless identifier.blank? || skip_exist

        self.identifier = generate_random_identifier
      end

      def generate_random_identifier
        chars = ('a'..'z').to_a

        chars.to_a.slice(rand(25), 1).join +
          Array.new(13) { chars[rand(chars.size)] }.join # instead of String.random(13)
      end

      # This method is called from models which
      # inherit from OnApp::Models::Base
      # to set fields that should be excluded
      # from max length validation
      def self.exclude_from_length_validation(*fields)
        @_excluded_from_length_validation = fields
        @_excluded_from_length_validation.map!(&:to_sym)
      end

      # Returns list of fields which were excluded
      # from length validation
      def self.excluded_fields_from_length_validation
        @_excluded_from_length_validation || []
      end

      # Find attributes columns types (:string)
      # and check it's length.
      # Adds errors to model if field's value is longer that maximum_length
      def check_fields_length
        types_to_check = [:string]
        maximum_length = 255

        # select all columns with :string type
        columns = self.class.columns.inject([]) do |array, column|
          array << column.name.to_sym if types_to_check.include? column.type
          array
        end

        errors_found = false
        # go through all columns, except for columns which were explicitly asked to be omitted
        (columns - self.class.excluded_fields_from_length_validation).each do |column|
          # skip fields that already have :length validation
          next if self.class.validators_on(column).any? { |validator| validator.kind == :length }
          if self.read_attribute(column).to_s.length > maximum_length
            self.errors.add column, I18n.t('.errors.messages.too_long', :count => maximum_length)
            errors_found = true
          end
        end

        errors_found
      end

      def to_xml(options = {}, &block)
        s_options = {}
        rewrite_options = !!options.delete(:rewrite_options)
        [:methods, :except, :user, :show_users_count, :show_root_password, :only].each do |key|
          if rewrite_options
            s_options[key] = options[key] if options.key? key
          else
            s_options[key] = options[key] unless options.key? key
          end
        end
        options[:skip_types] ||= false
        options[:dasherize] ||= false
        options[:root] ||= ActiveSupport::Inflector.underscore(self.class.to_s).tr('/', '_')
        serializable_hash(s_options).to_xml(options, &block)
      end

      def serializable_hash(options=nil)
        options = {} if options.nil?
        options[:methods] ||= self.class::API_METHODS if defined?(self.class::API_METHODS)
        options[:include] ||= self.class::API_INCLUDE if defined?(self.class::API_INCLUDE)
        options[:except] ||= self.class::API_EXCEPT if defined?(self.class::API_EXCEPT)
        ser_hash = super(options).stringify_keys
        self.class::API_METHODS_KEY_NAME_REWRITES.each{|pattern| ser_hash = ser_hash.rename_key(pattern)} if defined?(self.class::API_METHODS_KEY_NAME_REWRITES)
        ser_hash[:cdn_reference] = self.remote_id if (options[:skip_cdn_reference].nil? && self.respond_to?(:remote_id) && self.remote_id.present?)
        ser_hash
      end

      def as_json(options={}, &block)
        options = {} if options.nil?
        options[:root] = ActiveSupport::Inflector.underscore(self.class.model_name).tr('/', '_') unless options.key?(:root)
        super(options, &block)
      end

      alias_method :original_lock!, :lock!

      def with_lock(lock = true)
        transaction do
          original_lock!(lock)
          yield
        end
      end

      ## Lock an object
      def lock!
        return unless self.respond_to?(:locked)
        if self.new_record?
          self.locked = true
        else
          self.update_attribute(:locked, true)
        end
      end

      ## Unlock an object
      def unlock!
        return unless self.respond_to?(:locked)
        if self.new_record?
          self.locked = false
        else
          self.update_attribute(:locked, false)
        end
      end

      ## Unavailable for editing
      def unavailable?
        return true if self.respond_to?(:built) && !built?
        return true if self.respond_to?(:locked) && locked?
        return false
      end

      # TODO: return +unlocked+ scope when Rails will be stable.
      # This time +unlocked+ class-method is using
      # named_scope :unlocked, :conditions => {:locked => false}
      # scope :unlocked, where(:locked => false)

      def set_to_all_integer_attributes(value)
        self.attributes.each_key do |x|
          self.send(:"#{x}=", value.to_i) if self[x].nil? && self.class.columns_hash[x].type == :integer
        end
      end

      # Overwrite this method from ActiveRecord::Base
      # to handle any exceptions during attributes mass assignment
      def attributes=(new_attributes)
        super(new_attributes)
      rescue Exception => e
        if Rails.env.development?
          raise # do not handle error in development mode
        else
          raise OnApp::AttributeAssigningError.new(e.message)
        end
      end

      # returns array of recipe ids assigned to this object
      def recipes_to_run(event_types)
        return [] unless self.respond_to?(:recipe_joins)
        recipe_joins.where(event_type: event_types).pluck(:recipe_id)
      end

      class << self
        def concerned_with(*concerns)
          concerns.each do |concern|
            dependency = if concern.is_a?(Hash)
                           if concern[:absolute]
                             concern[:path]
                           else
                             File.join name.underscore.split('/'), concern[:path].to_s
                           end
                         else
                           File.join name.underscore.split('/'), concern.to_s
                         end

            require_dependency dependency
          end
        end

        def unlocked
          where(:locked => false)
        end

        def step_timer(from = Time.now, to = Time.now, step = 1.hour, &block)
          to_time = to.utc.beginning_of_hour
          from_time = from.utc.beginning_of_hour
          while from_time < to_time
            start_time = from_time
            from_time += step

            yield(start_time.strftime("%Y-%m-%d %H:%M:%S"), from_time.strftime("%Y-%m-%d %H:%M:%S"))
          end
        end

        protected

        def search_fields(*fields)
          return false if fields.empty?
          singleton_class.send(:define_method, :with_query_string) do |query_string|
            c = connection
            underscored_query = query_string.underscore
            escaped_query = query_string.gsub('%', '\%').gsub('_', '\_').downcase
            the_same = underscored_query == escaped_query

            query_string = fields.map do |field|
              column = field.to_s.include?('.') ? field : "#{c.quote_table_name(self.table_name)}.#{c.quote_column_name(field)}"

              arr = ["LOWER(#{column}) LIKE :query"]
              arr << "LOWER(#{column}) LIKE :query2" unless the_same

              arr
            end.flatten.uniq.join(' OR ')

            where(query_string, :query => "%#{escaped_query}%", :query2 => "%#{underscored_query}%")
          end
        end
      end
    end
  end
end