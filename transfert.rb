#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bunny"
require 'concurrent'

STDOUT.sync = true

fromConn = Bunny.new(:host => "rabbitmq")
fromConn.start

toConn = Bunny.new(:host => "rabbitmq2")
toConn.start

$dequeuedCounter = Concurrent::AtomicFixnum.new(0)
$channels = []
{ "queue1" => true, "queue2" => true }.each do |queueName, durable|
  fromChannel = fromConn.create_channel
  toChannel = toConn.create_channel
  $channels << fromChannel
  $channels << toChannel

  fromQueue = fromChannel.queue(queueName, :durable => durable)
  toQueue = toChannel.queue(queueName, :durable => durable)
  x  = toChannel.default_exchange
  
  puts "Subscribe to #{queueName}"
  fromQueue.subscribe do |delivery_info, metadata, payload|
      x.publish(payload, :routing_key => toQueue.name)
      $dequeuedCounter.increment
  end
end

$lastSeenDequeuedCounter = 0
$numberOfUnchangedPrints = 0

while $numberOfUnchangedPrints < 10
  sleep 2.0
  l = $dequeuedCounter.value
  diff = l - $lastSeenDequeuedCounter
  puts "#{l} : #{diff/2}"
  $numberOfUnchangedPrints += 1 if diff == 0
  $lastSeenDequeuedCounter = l
end

$channels.each(&:close)

