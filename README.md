# Rails4SessionFlashBackport

Different versions of Rails have stored flash messages in different objects in
the session, making it a pain to upgrade without nuking everyones session. The
good ol' `ActionDispatch::Session::SessionRestoreError` making life difficult.

This gem was created because we wanted to be able to keep our users Rails 2
sessions working on Rails 3, and we figured as long as we're going to be doing
crazy stuff we might as well go and use the far more sensible practice from
Rails 4 of storing the flash as basic ruby types.

When using this gem on a Rails 2 or 3 app:

 - Flash messages are stored as basic objects in the Rails 4 style.
 - Flash messages in the Rails 2 format can be successfully decoded.
 - Flash messages in the Rails 3 format can be successfully decoded.
 - Flash messages in the Rails 4 format can be successfully decoded.

This actually makes it possible to bounce requests from a Rails 2 server, to a
Rails 3 server and back again so long as both servers are using this gem. Very
helpful when you're doing a big Rails 2 => 3 upgrade and want to run a few
Rails 3 servers concurrently with your Rails 2 cluster to verify everything is
fine and performance is acceptable without
having to do the all-in switch.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_4_session_flash_backport'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_4_session_flash_backport

Copyright
---------

Copyright (c) 2012 [Envato](http://envato.com), [Lucas Parry](http://github.com/lparry), [chendo](http://github.com/chendo). See LICENSE.txt for further details.

