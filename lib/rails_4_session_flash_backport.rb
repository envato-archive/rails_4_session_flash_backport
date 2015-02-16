# encoding: utf-8
require "rails_4_session_flash_backport/version"

case Rails.version
when /\A2\./
  require 'rails_4_session_flash_backport/rails2/flash_hash'
  require 'rails_4_session_flash_backport/rails2/session_with_indifferent_access'
when /\A3\.0\./
  require 'rails_4_session_flash_backport/rails3-0/flash_hash'
when /\A3\./
  require 'rails_4_session_flash_backport/rails3-1/flash_hash'
when /\A4\./
  require 'rails_4_session_flash_backport/rails4/flash_hash'
else
  Rails.logger.warn "rails_4_session_flash_backport doesnt yet do anything on Rails #{Rails.version}"
end
