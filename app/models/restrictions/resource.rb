module Restrictions
  class Resource < OnApp::Models::Base
    RESTRICTION_TYPES = %w( by_billing_plan by_user_group ).freeze
    BY_USER_GROUP_TYPE = 'by_user_group'.freeze

    attr_accessible :identifier, :restriction_type
    attr_readonly :identifier, :restriction_type

    has_many :sets_resources, class_name: 'Restrictions::SetsResource', dependent: :destroy
    has_many :sets, through: :sets_resources

    validates :identifier, presence: true, uniqueness: { scope: :restriction_type }
    validates :restriction_type, presence: true, inclusion: RESTRICTION_TYPES

    def self.restriction_type_by_user_id_and_identifier(user_id, identifier)
      joins("INNER JOIN `restrictions_sets_resources` \
                     ON (`restrictions_sets_resources`.`resource_id` = `restrictions_resources`.`id`) \
             INNER JOIN `restrictions_sets` \
                     ON (`restrictions_sets`.`id` = `restrictions_sets_resources`.`set_id`) \
             INNER JOIN `restrictions_sets_roles` \
                     ON (`restrictions_sets_roles`.`set_id` = `restrictions_sets`.`id`) \
       RIGHT OUTER JOIN `roles` \
                     ON (`roles`.`id` = `restrictions_sets_roles`.`role_id`) \
        LEFT OUTER JOIN `users_roles` \
                     ON (`roles`.`id` = `users_roles`.`role_id`) \
       RIGHT OUTER JOIN `users` \
                     ON (`users`.`id` = `users_roles`.`user_id`)").
          where("(`users`.`id` = :user_id \
                    AND (`restrictions_resources`.`identifier` = :identifier \
                     OR `restrictions_resources`.`identifier` IS NULL))",
                user_id: user_id, identifier: identifier).pluck(:restriction_type).compact.uniq
    end

    def label
      "#{ name } (#{ restriction_name })"
    end

    def name
      "#{ I18n.t("restrictions.resources.#{ identifier }") }"
    end

    def restriction_name
      "#{ I18n.t("restrictions.types.#{ restriction_type }") }"
    end
  end
end