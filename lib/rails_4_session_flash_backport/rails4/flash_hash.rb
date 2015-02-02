require 'active_support/core_ext/hash/except'
require 'action_dispatch'
require 'action_dispatch/middleware/flash'

# Backport discarding before session persist to rails 4
module ActionDispatch
  class Flash
    class FlashHash
      def self.from_session_value(value)
        flashes = discard = nil

        case value
        when ::ActionController::Flash::FlashHash # Rails 2.x
          flashes = Hash.new.update(value)
          discard = value.instance_variable_get(:@used).select{|a,b| b}.keys
        when ::ActionDispatch::Flash::FlashHash # Rails 3.1, 3.2
          flashes = value.instance_variable_get(:@flashes)
          discard = value.instance_variable_get(:@used)
        when Hash # Rails 4.0, we backported to 2.3 too
          flashes = value['flashes']
          discard = value['discard']
        end

        flashes ||= {}
        if discard
          flashes.except!(*discard)
        end

        new(flashes, flashes.keys)
      end

      def to_session_value
        flashes_to_keep = @flashes.except(*@discard)
        return nil if flashes_to_keep.empty?
        {'flashes' => flashes_to_keep}
      end
    end
  end
end

# This magic here allows us to unmarshal the old Rails 2.x ActionController::Flash::FlashHash
module ActionController
  module Flash
    class FlashHash < Hash
      def self._load(args)
        {}
      end
    end
  end
end

