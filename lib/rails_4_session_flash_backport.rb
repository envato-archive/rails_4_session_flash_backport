# encoding: utf-8
require "rails_4_session_flash_backport/version"

case Rails.version.to_i
when 2
  require 'rails_4_session_flash_backport/rails2'
when 3
  require 'rails_4_session_flash_backport/rails3'
else
  Rails.logger.warn "rails_4_session_flash_backport doesnt yet do anything on Rails #{Rails.version}"
end
