#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bunny"
require 'concurrent'

STDOUT.sync = true

fromConn = Bunny.new(:host => "rabbitmq")
fromConn.start

fromChannel = fromConn.create_channel
fromQueue  = fromChannel.queue("spool")

$dequeuedCounter = Concurrent::AtomicFixnum.new(0)
fromQueue.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
  $dequeuedCounter.increment
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


fromConn.close
