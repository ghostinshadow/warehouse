module FactoryGirl
  module Syntax
    module Methods
      def create_with_info(*args, &block)
        create_without_info(*args, &block)
      rescue => e
        raise unless e.is_a? ActiveRecord::RecordInvalid
        raise $!, "#{e.message} (Class #{e.record.class.name})", $!.backtrace
      end
      alias_method_chain :create, :info
    end
  end
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
