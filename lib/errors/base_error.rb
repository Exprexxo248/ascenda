module Errors
  class BaseError < StandardError
    attr_reader :message

    def initialize(message:)
      @message = message
      super
    end
  end
end
