require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'concurrent-ruby'
end

require 'concurrent'

# Note: we cannot replicate Elixir's example exactly in having the public API
# call a private function with `call` or `cast` interally. From the
# [docs](http://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/Async.html):
#
# > External method calls should always use the async and await proxy methods.
# When one method calls another method, the async proxy should rarely be used
# and the await proxy should never be used.
#
# >When an object calls one of its own methods using the await proxy the second
# call will be enqueued behind the currently running method call. Any attempt
# to wait on the result will fail as the second call will never run until after
# the current call completes.
#
# > Calling a method using the await proxy from within a method that was itself
# called using async or await will irreversibly deadlock the object. Do not do
# this, ever.
class ShoppingList
  include Concurrent::Async

  def initialize
    # From the Concurrent::Async docs:
    # When defining a constructor it is critical that the first line be a call
    # to super with no arguments. The super method initializes the background
    # thread and other asynchronous components.
    super

    @list = {}
  end

  # Add an item to the list
  # @param [String] item_name
  # @param [Integer] number_of_items
  # @note if an item already exists, this will overwrite it
  def put(item_name, number_of_items)
    @list.merge({ item_name => number_of_items })
  end

  # Fetch an item from the list
  #
  # @param [String] item_name
  # @return [Integer] the number of that item on the list. If the item does not
  #   exist, returns 0.
  def get(item_name)
    @list.fetch(item_name, 0)
  end

  # Show the full contents of the list
  # @return [Hash]
  def all
    @list
  end

  # Format list in a user-friendly way
  # @return [String]
  def readable
    @list.each_with_object("My List\n\n") do |(item, count), output|
      output << "* #{item} - #{count}"
    end
  end
end

shopping_list = ShoppingList.new

print '> '
while (input = gets)
  case input
  when /^[qQxX]/
    puts 'Quitting...'
    exit(0)
  when /^l(ist)?/
    puts shopping_list.await.readable.value
  when /^add (?<item>\D+)(?<count>\d+)/
    item = Regexp.last_match[:item]
    count = Regexp.last_match[:count]
    puts "Adding: #{count} #{item}"
    shopping_list.async.put(item, count)
  when /^await/ then hello.await.hello
  when /^new-async/ then HelloAsync.new.async.hello
  when /^new-await/ then HelloAsync.new.await.hello
  else puts "Received unknown input: #{input}"
  end

  print '> '
end

# TODO
#
# - [ ] Try out the ShoppingList class
# - [ ] Make some CLI actions to interact with it (add item, get item, list all)



# Resources
#
# - https://elixir-lang.org/getting-started/mix-otp/genserver.html
# - http://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/Async.html
