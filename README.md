# Rails4SessionFlashBackport
[![Gem Version](https://badge.fury.io/rb/rails_4_session_flash_backport.png)](http://badge.fury.io/rb/rails_4_session_flash_backport)
[![Build Status](https://travis-ci.org/envato/rails_4_session_flash_backport.png)](https://travis-ci.org/envato/rails_4_session_flash_backport)

Different versions of Rails have stored flash messages in different objects in
the session, making it a pain to upgrade without nuking everyones session. The
good ol' `ActionDispatch::Session::SessionRestoreError` making life difficult.

This gem was created because we wanted to be able to keep our users Rails 2
sessions working on Rails 3, and we figured as long as we're going to be doing
crazy stuff we might as well go and use the far more sensible practice from
Rails 4 of storing the flash as basic ruby types and sweeping the flash before
persisting into the session.

For more details of the how and why, check out our blog post [Happily upgrading
Ruby on Rails at production scale][blog-post].

[blog-post]: http://webuild.envato.com/blog/upgrading-ruby-on-rails-at-production-scale/

When using this gem on a Rails 2.3, 3.1+ or 4 app:

 * Flash messages are stored as basic objects in the Rails 4 style, pre-swept.
 * Flash messages in the Rails 2 format can be successfully decoded.
 * Flash messages in the Rails 3.1 format can be successfully decoded.
 * Flash messages in the Rails 4 format can be successfully decoded.

This actually makes it possible to bounce requests from a Rails 2 server, to a
Rails 3 server and back again so long as both servers are using this gem. Very
helpful when you're doing a big Rails 2 => 3 upgrade and want to run a few
Rails 3 servers concurrently with your Rails 2 cluster to verify everything is
fine and performance is acceptable without having to do the all-in switch.

### Rails 2

Additionally, on Rails 2 we include some patches for the SessionHash and
CookieStore in order to make them act more like a HashWithIndifferentAccess,
like the versions on Rails 3, so that your session_id can survive a trip to
Rails 3 and back.

### Rails 3.0

Rails 3.0 was a weird half-way house between 2.x and 3.1. The 3.0 to 3.1
upgrade gave many of us an [Argument Error (dump format error)
problem][argumenterror-so].

[argumenterror-so]: http://stackoverflow.com/questions/9120501/what-causes-the-argumenterror-dump-format-error

Consequently rails 3.0 with this gem can decode a rails 2.3 flash and a rails
3.0 flash but not a rails 3.1+ or 4.x flash.

Once this gem is installed, rails 3.0 flashes will be stored in the rails 4
style simple format and can be used with any other rails version with this gem,
and from rails 4 without the gem, so it actually alleviates the upgrade pain.
Be aware that older sessions may still contain the older formatted hash if
you've been running on rails 3.0 for some time.

Using this gem from rails 2.3 will completely skip the issue.

### Rails 4

This gem also now backports functionality for Rails 2, 3 and 4 which sweeps the
flash before persisting it into the session. This means putting large objects
into `flash.now` shouldn't cause `CookieOverflow` errors.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_4_session_flash_backport'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_4_session_flash_backport

## Copyright

Copyright (c) 2012 [Envato](http://envato.com), [Lucas Parry](http://github.com/lparry), [chendo](http://github.com/chendo), [sj26](http://github.com/sj26). See LICENSE.txt for further details.

