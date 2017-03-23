---
title: 'Ruby Blocks: Procs and Lambdas'
categories: Tech
tags:
  - Ruby
  - Foundation
  - Block
  - Proc
  - Lambda
---

In this article, we're going to talk about the Blocks in Ruby: Procs and Lambdas.

### What are procs and lambdas?

``` ruby
a_proc = Proc.new { puts "yeah!" }
a_proc.call # => yeah!

a_lambda = lambda { puts "yeah!" }
a_lambda = -> { puts "yeah!" } # short lambda syntax in 1.9
a_lambda.call # => yeah!
```

While it looks like these are all very similar, there are subtle differences that I will cover below.

<!-- more -->

### Differences between procs and lambdas

1. **Lambdas check the number of arguments, while procs do not**

``` ruby
a_proc = Proc.new { |s| puts "yeah!" }
a_proc.call # => yeah!

a_lambda = lambda { |s| puts "yeah!" }
a_lambda.call # => wrong number of arguments (0 for 1) (ArgumentError)
```

2. **Lambdas and procs treat _return_ keyword differently**

``` ruby
def test_proc
  Proc.new { return 1 }.call
  return 0
end

def test_lambda
  lambda { return 1 }.call
  return 0
end

puts test_proc # => 1
puts test_lambda # => 0
```

As you can see, the proc returned from the `test_proc` method, and the lambda didn't.

### Passing a block to a method in different ways

- **With the & (ampersand) symbol :**

``` ruby
def a_method(arg, &block)
  puts arg
  block.call
end

a_method('Hi') { puts "I'm a Proc!" }
# => Hi
# => I'm a Proc!
```

- **With _yield_ keywbowrd**

``` ruby
def a_method(arg)
  puts arg
  yield
end

a_method('Hi') { puts "I'm a Proc!" }
# => Hi
# => I'm a Proc!
```

