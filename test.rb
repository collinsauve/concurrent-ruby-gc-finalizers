#!/usr/bin/env ruby

require_relative 'test_me'

puts 'Before Concurrent'
TestMe.run_tests
puts ''

require 'concurrent'

puts 'After Concurrent'
TestMe.run_tests
puts ''
