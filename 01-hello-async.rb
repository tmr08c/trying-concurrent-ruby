require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'concurrent-ruby'
end

require 'concurrent'

class HelloAsync
  include Concurrent::Async

  def hello_method
    sleep(3)
    puts "Hello! My object id is '#{object_id}' and I'm running in thread '#{Thread.current.object_id}'."
  end
end

hello_instance = HelloAsync.new

print '> '
while (input = gets)
  case input
  when /^[qQxX]/
    puts 'Quitting...'
    exit(0)
  when /^l(ist)?/ then puts "Currently have #{Thread.list.count} threads."
  when /^async/ then hello_instance.async.hello_method
  when /^await/ then hello_instance.await.hello_method
  when /^new-async/ then HelloAsync.new.async.hello_method
  when /^new-await/ then HelloAsync.new.await.hello_method
  else puts "Received unknown input: #{input}"
  end

  print '> '
end
