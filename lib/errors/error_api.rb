module Errors
  module ErrorApi
    EXCEPTIONS = {
      "BadRequest" => { status: 400, error_code: 40_002, message: "Service Bad Request" },
      "ActionController::ParameterMissing" => {
        status: 400, error_code: 40_003, message: "Parameters Are Missing"
      },
      "Errors::InvalidTypeError" => { status: 400, error_code: 40_004, message: "Invalid Type" },
      "Date::Error" => { status: 400, error_code: 40_005, message: "Date Invalid" }

    }.freeze

    module Handler
      def self.included(klass)
        klass.class_eval do
          EXCEPTIONS.each do |error_name, context|
            unless Errors::ErrorApi.const_defined?(error_name)
              Errors::ErrorApi.const_set(error_name, Class.new(Errors::BaseError))
              error_name = "Errors::#{error_name}"
            end
            rescue_from error_name do |error|
              render status: context[:status], json: { error_code: context[:error_code],
                                                       message: context[:message],
                                                       detail: error&.message }.compact
            end
          end
        end
      end
    end
  end
end
