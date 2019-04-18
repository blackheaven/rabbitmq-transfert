#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bunny"

STDOUT.sync = true

toConn = Bunny.new(:host => "rabbitmq")
toConn.start

toChannel = toConn.create_channel
toQueue  = toChannel.queue("spool")
x  = toChannel.default_exchange

(1).upto(10).each do |index|
    x.publish("Payload #{index}", :routing_key => toQueue.name)
end

sleep 1.0
toConn.close
