# encoding: utf-8
require "rails_4_session_flash_backport/version"

case Rails.version.to_i
when 2
  require 'rails_4_session_flash_backport/rails2/flash_hash'
  require 'rails_4_session_flash_backport/rails2/session_with_indifferent_access'
when 3
  require 'rails_4_session_flash_backport/rails3/flash_hash'
when 4
  Rails.logger.warn "You're on Rails 4 so it's probably safe to remove the rails_4_session_flash_backport gem!"
else
  Rails.logger.warn "rails_4_session_flash_backport doesnt yet do anything on Rails #{Rails.version}"
end
