# encoding: utf-8
require 'action_controller/flash'
require 'action_controller/test_process'
# Backport Rails 4 style storing the flash as basic ruby types to Rails 2
module ActionController #:nodoc:
  module Flash
    class FlashHash
      def self.from_session_value(value)
        flash = case value
                when FlashHash # Rails 2.3
                  value
                when ::ActionDispatch::Flash::FlashHash # Rails 3.2
                  flashes = value.instance_variable_get(:@flashes) || {}
                  used_set = value.instance_variable_get(:@used) || []
                  used = Hash[flashes.keys.map{|k| [k, used_set.include?(k)] }]
                  new_from_values(flashes, used)
                when Hash # Rails 4.0
                  flashes = value['flashes'] || {}
                  discard = value['discard']
                  used = Hash[flashes.keys.map{|k| [k, discard.include?(k)] }]

                  new_from_values(flashes, used)
                else
                  new
                end
        flash
      end

      def to_session_value
        return nil if empty?
        rails_3_discard_list = @used.map{|k,v| k if v}.compact
        {'discard' => rails_3_discard_list, 'flashes' => Hash[to_a]}
      end

      def store(session, key = "flash")
        session[key] = to_session_value
      end

      private

      def self.new_from_values(flashes, used)
        new.tap do |flash_hash|
          flashes.each do |k, v|
            flash_hash[k] = v
          end
          flash_hash.instance_variable_set("@used", used)
        end
      end
    end

    module InstanceMethods #:nodoc:
      protected
      def flash #:doc:
        if !defined?(@_flash)
          @_flash = Flash::FlashHash.from_session_value(session["flash"])
          @_flash.sweep
        end

        @_flash
      end
    end
  end
  module TestResponseBehavior #:nodoc:
    # A shortcut to the flash. Returns an empty hash if no session flash exists.
    def flash
      ActionController::Flash::FlashHash.from_session_value(session["flash"]) || {}
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
