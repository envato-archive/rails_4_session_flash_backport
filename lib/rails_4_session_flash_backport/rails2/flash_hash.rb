# encoding: utf-8
require 'active_support'
require 'action_controller/flash'
require 'action_controller/test_process'
# Backport Rails 4 style storing the flash as basic ruby types to Rails 2
module ActionController #:nodoc:
  module Flash
    class FlashHash
      def self.from_session_value(value)
        case value
        when FlashHash # Rails 2.3
          value.tap(&:sweep)
        when ::ActionDispatch::Flash::FlashHash # Rails 3.2
          flashes = value.instance_variable_get(:@flashes)
          if discard = value.instance_variable_get(:@used).presence
            flashes.except!(*discard)
          end

          new_from_session(flashes)
        when Hash # Rails 4.0
          flashes = value['flashes'] || {}
          if discard = value['discard'].presence
            flashes.except!(*discard)
          end

          new_from_session(flashes)
        else
          new
        end
      end

      def to_session_value
        return nil if empty?
        discard = @used.select { |key, used| used }.keys
        {'flashes' => Hash[to_a].except(*discard)}
      end

      def store(session, key = "flash")
        session[key] = to_session_value
      end

      private

      def self.new_from_session(flashes)
        new.tap do |flash|
          flashes.each do |key, value|
            flash[key] = value
            flash.discard key
          end
        end
      end
    end

    module InstanceMethods #:nodoc:
      protected
      def flash #:doc:
        if !defined?(@_flash)
          @_flash = Flash::FlashHash.from_session_value(session["flash"])
        end

        @_flash
      end
    end
  end
  module TestResponseBehavior #:nodoc:
    # A shortcut to the flash.
    def flash
      ActionController::Flash::FlashHash.from_session_value(session["flash"])
    end
  end
end

# This magic here allows us to unmarshal a Rails 3.2 ActionDispatch::Flash::FlashHash
module ActionDispatch
  class Flash
    class FlashHash
      def self._load(args)
        {}
      end
    end
  end
end
