require 'eventmachine'

# Sanity-check that our EventMachine has the required methods:
unless EventMachine.respond_to?(:attach_server)
  raise "You need an EventMachine that supports .attach_server. That can be EventMachine-LE or EventMachine 1.0.4 and above."
end

# Based on Patrick Collison's commit to stripe/thin:
# https://github.com/stripe/thin/commit/42e29ba23a136a30dc11a1c9dff1fe1187dc9eee
#
module Thin
  module Backends
    # Backend to act as a TCP server using an already opened file
    # descriptor. Currently requires a patched EventMachine like
    # https://github.com/ibc/EventMachine-LE
    #
    # @example
    #
    #   Thin::Server.new(MyApp,
    #                    backend: Thin::Backends::AttachSocket,
    #                    socket: IO.for_fd(6))
    #
    # If you're running thin inside a reactor with other servers, then pass
    # preserve_reactor: true. This ensures that when you stop the Thin server,
    # it will not stop your reactor.
    #
    # If you're doing that you probably also want to pass signals: false so that
    # you can control when thin shuts down:
    #
    # @example
    #
    #   Thin::Server.new(MyApp,
    #                    backend: Thin::Backends::AttachSocket,
    #                    socket: IO.for_fd(6),
    #                    signals: false,
    #                    preserve_reactor: true)
    #
    class AttachSocket < Base
      def initialize(host, port, options)
        @socket = options[:socket]
        @preserve_reactor = !!options[:preserve_reactor]
        super()
      end

      def connect
        @signature = EventMachine.attach_server(@socket, Connection, &method(:initialize_connection))
      end

      def disconnect
        EventMachine.stop_server(@signature)
      end

      def to_s
        "socket:#{@socket.inspect}"
      end

      def stop!
        if @preserve_reactor
          # This is the code for super, with the EM::stop call removed.
          @running  = false
          @stopping = false

          @connections.each { |connection| connection.close_connection_after_writing }
          close
        else
          super
        end
      end
    end
  end
end
