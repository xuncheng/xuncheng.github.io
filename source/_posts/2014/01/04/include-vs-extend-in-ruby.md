---
title: 'Include vs Extend in Ruby'
categories: Tech
tags:
  - Ruby
  - Foundation
---

In this article, we will study `Include` and `Extend` and see the differences between those two. Include is for adding methods to an instance of a class and extend is for adding methods to any type of object(Class or an instance of Class). Let's take a look at a small example:

``` ruby
module Foo
  def bar
    puts 'foobar'
  end
end

class IncludeModule
  include Foo
end

class ExtendModule
  extend Foo
end

class Plain; end
```

<!-- more -->

### on IncludeModule:

``` ruby
IncludeModule.bar # => undefined method `bar' for IncludeModule:Class (NoMethodError)
IncludeModule.new.bar # => 'foobar'
```

As you can see, include a module inside a class will add the **instance methods** defined in the module **to the instances of the class including the module**.

### on ExtendModule:

``` ruby
ExtendModule.bar # => 'foobar'
ExtendModule.new.bar # => undefined method `bar' for #<ExtendModule:0x007f848197aee8> (NoMethodError)
```

Extend a module inside a class will add the **instance methods** defined in the module **to the extended class**.

### on an instance of Plain Class:

``` ruby
plain = Plain.new
plain.bar # => undefined method `bar' for #<Plain:0x007fb252086f90> (NoMethodError)
plain.extend(Foo)
plain.bar # => 'foobar'

new_plain = Plain.new
new_plain.bar # => undefined method `bar' for #<Plain:0x007fb252086f90> (NoMethodError)
```

Extend a module on an object will add the **instance methods** defined in the module **to the object**, and the module **will not available in other objects**.

### Footnotes

- Source Code: [https://gist.github.com/xuncheng/0ba83a5a160963a53809](https://gist.github.com/xuncheng/0ba83a5a160963a53809)
