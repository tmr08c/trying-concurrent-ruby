#  Trying Concurrent Ruby

I am using this repo as a learning ground for working with the [`concurrent-ruby` gem](https://github.com/ruby-concurrency/concurrent-ruby).

## Running

These scrips leverage [inline Bundler](https://bundler.io/guides/bundler_in_a_single_file_ruby_script.html) to allow for them to be self-contained. As a result, they can be run with:

```
ruby script-name.rb
```

## List

* `01-hello-async.rb` - basic example using the [Async mixin](http://ruby-concurrency.github.io/concurrent-ruby/master/Concurrent/Async.html).
