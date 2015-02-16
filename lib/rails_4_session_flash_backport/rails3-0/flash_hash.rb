# encoding: utf-8
require 'active_support/core_ext/hash/except'
require 'action_dispatch'
require 'action_dispatch/middleware/flash'

# Backport Rails 4 style storing the flash as basic ruby types to Rails 3.0
module ActionDispatch
  class Request < Rack::Request
    def flash
      @env[Flash::KEY] ||= Flash::FlashHash.from_session_value(session["flash"])
    end
  end

  class Flash
    KEY = 'action_dispatch.request.flash_hash'.freeze

    class FlashHash < Hash
      def self.from_session_value(value)
        flashes = discard = nil

        case value
        when ::ActionController::Flash::FlashHash # Rails 2.x
          flashes = Hash.new.update(value)
          discard = value.instance_variable_get(:@used).select{|a,b| b}.keys
        when ::ActionDispatch::Flash::FlashHash # Rails 3.1, 3.2
          flashes = value.tap(&:sweep).to_hash
        when Hash # Rails 4.0, we backported to 2.3 too
          flashes = value['flashes']
          discard = value['discard']
        end

        flashes ||= {}
        if discard
          flashes.except!(*discard)
        end

        new_from_session(flashes)
      end

      def to_session_value
        flashes_to_keep = except(*@used)
        return nil if flashes_to_keep.empty?
        {'flashes' => flashes_to_keep}
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
