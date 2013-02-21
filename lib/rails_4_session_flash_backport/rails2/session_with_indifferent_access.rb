# The SessionHash acts like a HashWithIndifferentAccess on Rails 3, which causes
# problems with the session_id among other things. On Rails 2 the session_id is
# stored as session[:session_id], if we take that session to Rails 3 it becomes
# session["session_id"], and if we bring it back to Rails 2 it's still
# session["session_id"], but Rails checks session[:session_id], finds nothing
# and generates a new one. This is unacceptable.
#
# We've patched the SessionHash to #to_s keys before it stores them, and to
# fall back from the string key to the symbol if needed.
module ActionController::Session
  class AbstractStore
    class SessionHash < Hash
        def [](key)
          load! unless @loaded
          super(key.to_s) || super(key)
        end

        def has_key?(key)
          load! unless @loaded
          super(key.to_s) || super(key)
        end

        def []=(key, value)
          load! unless @loaded
          super(key.to_s, value)
        end
    end
  end
end

# We've also had to patch the cookie store, to make it use for the string
# version of "session_id", again falling back to the symbol if needed.
module ActionController
  module Session
    class CookieStore
        def load_session(env)
          data = unpacked_cookie_data(env)
          data = persistent_session_id!(data)
          [data["session_id"] || data[:session_id], data]
        end

        def extract_session_id(env)
          if data = unpacked_cookie_data(env)
            persistent_session_id!(data) unless data.empty?
            data["session_id"] || data[:session_id]
          else
            nil
          end
        end

        def inject_persistent_session_id(data)
          requires_session_id?(data) ? { "session_id" => generate_sid } : {}
        end

        def requires_session_id?(data)
          if data
            data.respond_to?(:key?) && !(data.key?("session_id") || data.key?(:session_id))
          else
            true
          end
        end
    end
  end
end

