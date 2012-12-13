# encoding: utf-8
require 'action_dispatch/middleware/flash'
# Backport Rails 4 style storing the flash as basic ruby types to Rails 3
module ActionDispatch
  class Request < Rack::Request
    def flash
      @env[Flash::KEY] ||= Flash::FlashHash.from_session_value(session["flash"]).tap(&:sweep)
    end
  end
  class Flash
    class FlashHash

      def self.from_session_value(value)
        case value
        when ::ActionController::Flash::FlashHash # Rails 2.x
          new(value, value.instance_variable_get(:@used).select{|a,b| b}.keys)
        when ::ActionDispatch::Flash::FlashHash # Rails 3.1, 3.2
          new(value.instance_variable_get(:@flashes), value.instance_variable_get(:@used))
        when Hash # Rails 4.0, we backported to 2.3 too
          new(value['flashes'], value['discard'])
        else
          new
        end
      end

      def to_session_value
        return nil if empty?
        {'discard' => @used.to_a, 'flashes' => @flashes}
      end

      def initialize(flashes = {}, discard = []) #:nodoc:
        @used    = Set.new(discard)
        @closed  = false
        @flashes = flashes
        @now     = nil
      end

    end

    def call(env)
      @app.call(env)
    ensure
      session    = env['rack.session'] || {}
      flash_hash = env[KEY]

      if flash_hash
        if !flash_hash.empty? || session.key?('flash')
          session["flash"] = flash_hash.to_session_value
          new_hash = flash_hash.dup
        else
          new_hash = flash_hash
        end

        env[KEY] = new_hash
      end

      if session.key?('flash') && session['flash'].nil?
        session.delete('flash')
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
