module Edash
  module Api
    class Progress
      STARTED  = 'started'
      FINISHED = 'finished'

      attr_reader :status, :percentage

      def initialize(status, percentage = 0)
        @status, @percentage = status, percentage
      end

      def to_json
        "[\"#{@status}\",\"#{@percentage}\"]"
      end
    end
  end
end
