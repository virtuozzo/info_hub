require 'factory_girl_rails'

module FactoryGirlAdditions
  # create instance without running callbacks and validations
  # callbacks will not work any more!
  def insert(*args)
    record = pure(*args)

    record.instance_eval do
      def __run_callbacks__(callbacks, &block)
        yield if block_given?
      end
    end

    record.save(validate: false)

    record
  end

  def pure(factory_name, *args)
    options = args.extract_options!
    traits = [:pure] | args
    FactoryGirl.build(factory_name, *traits, options)
  end

  def insert_list(name, amount, *traits_and_overrides, &block)
    amount.times.map { insert name, *traits_and_overrides, &block }
  end
end

def insert_list_in_one_query(klass, name, amount, *traits_and_overrides, &block)
  klass.import(amount.times.map { pure name, *traits_and_overrides, &block }, validate: false)
end

class NoCallbacksStrategy
  def association(runner)
    runner.run
  end

  def result(evaluation)
    evaluation.object.tap do |instance|
      instance.instance_eval do
        def __run_callbacks__(callbacks, &block)
          yield if block_given?
        end
      end
      evaluation.create(instance)
    end
  end
end

FactoryGirl.register_strategy(:no_callbacks, NoCallbacksStrategy)