Provides `Thin::Backends::AttachSocket` for booting a thin server on an already open
Socket.

This is useful when running thin inside [einhorn](https://github.com/stripe/einhorn), and
it requires either a recent [eventmachine](https://github.com/eventmachine/eventmachine) gem
(1.0.4 and up implement the required functions), or
[eventmachine-le](https://github.com/ibc/EventMachine-LE).

Installation
============

Either `gem install thin-attach_socket`, or add `gem 'thin-attach_socket'` to your
`Gemfile`, and run `bundle`.

Usage
=====

Thin allows you to configure the backend dynamically, so using thin-attach-socket is as
simple as:

```ruby
require 'thin/attach_socket'
Thin::Server.new(MyApp,
                 backend: Thin::Backends::AttachSocket,
                 socket: IO.for_fd(6))
```

By default thin will stop the EventMachine reactor when you stop the server, and this is
usually what you want. If you're running other servers on the reactor however, you should
pass `preserve_reactor: true` when constructing a new server, and this will not happen.

```ruby
require 'thin/attach_socket'
Thin::Server.new(MyApp,
                 backend: Thin::Backends::AttachSocket,
                 socket: IO.for_fd(6),
                 signals: false,
                 preserve_reactor: true)
```

If you do this, you need to make sure to stop the thin server before stopping the EM
reactor.

Meta-foo
========

thin-attach_socket is released under the Ruby License, http://www.ruby-lang.org/en/LICENSE.txt.

It was heavily based on the [work](https://github.com/stripe/thin/commit/42e29ba23a136a30dc11a1c9dff1fe1187dc9eee) of
Patrick Collison at Stripe.
