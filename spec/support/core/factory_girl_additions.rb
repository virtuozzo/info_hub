require 'factory_girl_rails'

module FactoryGirlAdditions
  # create instance without running callbacks and validations
  # callbacks will not work any more!
  def insert(*args)
    record = pure(*args)
    def record.run_callbacks(*args, &block)
      if block_given?
        block.arity.zero? ? yield : yield(self)
      end
    end
    record.save!
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

class NoCallbacksStrategy
  def association(runner)
    runner.run
  end

  def result(evaluation)
    evaluation.object.tap do |instance|
      def instance.run_callbacks(*args, &block)
        if block_given?
          block.arity.zero? ? yield : yield(self)
        end
      end
      evaluation.create(instance)
    end
  end
end

FactoryGirl.register_strategy(:no_callbacks, NoCallbacksStrategy)