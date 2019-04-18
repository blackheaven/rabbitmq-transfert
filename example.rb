#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bunny"

STDOUT.sync = true

fromConn = Bunny.new(:host => "rabbitmq")
fromConn.start

fromChannel = fromConn.create_channel
fromQueue  = fromChannel.queue("spool")
x  = fromChannel.default_exchange

fromQueue.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end

x.publish("Hello!", :routing_key => fromQueue.name)

sleep 1.0
fromConn.close
