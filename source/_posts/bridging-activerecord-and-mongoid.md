---
title: Bridging ActiveRecord and Mongoid
categories: Tech
tags:
  - Rails
  - Mongoid
date: 2015-09-16
---

最近我们的项目中同时用了 MySQL 和 MongoDB 数据库，但不能直接使用Rails提供的 `has_many` 和 `belongs_to` 在 ActiveRecord models 和 Mongoid documents 之间建立联系(associations)。

``` ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many :visits
end

# app/models/visit.rb
class Visit
  include Mongoid::Document
end

# in Rails console
User.find(1).visits
# => NoMethodError: undefined method `relation_delegate_class' for Visit:Class
```

<!-- more -->

为了更方便的在 ActiveRecord models 和 Mongoid documents 之间建立联系(associations)，我们可以写一点代码去封装它：

1. 在 ActiveRecord models 里实现 `has_many_documents`:

``` ruby
# lib/extensions/active_record/has_many_documents.rb
module Extensions::ActiveRecord::HasManyDocuments
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_documents(association_name, options = {})
      class_eval %<
        def #{association_name}
          #{association_name.to_s.singularize.classify}.where(#{name.underscore}_id: id)
        end
      >
    end
  end
end

ActiveRecord::Base.send(:include, Extensions::ActiveRecord::HasManyDocuments)
```

2. 在 `initializer` 里载入 `has_many_documents` 文件:

``` ruby
# config/initializers/extensions.rb
require File.join(Rails.root, 'lib', 'extensions', 'active_record', 'has_many_documents')
```

3. 在 Mongoid documents 里实现 `belongs_to_record`:

``` ruby
# app/models/concerns/mongoid/active_record_bridge.rb
module Mongoid
  module ActiveRecordBridge
    extend ActiveSupport::Concern

    included do
      def self.belongs_to_record(association_name, options={})
        association_class = options[:class_name] || association_name.to_s.singularize.classify
        class_eval %<
          field :#{association_name}_id, type: Integer
          index(#{association_name}_id: 1)
          def #{association_name}
            @#{association_name} ||= #{association_class}.where(id: #{association_name}_id).first if #{association_name}_id
          end
          def #{association_name}=(object)
            @#{association_name} = object
            self.#{association_name}_id = object.try :id
          end
        >
      end
    end
  end
end
```

现在你就可以在 ActiveRecord models 和 Mongoid documents 里定义 `1:N` 的关系了:

``` ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_many_documents :visits
end

# app/models/visit.rb
class Visit
  include Mongoid::Document
  include Mongoid::ActiveRecordBridge

  belongs_to_record :user
end

# in Rails console
User.find(1).visits
=> #<Mongoid::Criteria
     selector: {"user_id"=>1}
     options:  {}
     class:    Visit
     embedded: false>
```

现在一切工作正常，我在这篇文章里只简单的定义了 `1:N` 的关系，如果你的项目里还有更多的需求的话，也可以参考这篇文章的方法自行扩展。

## Footnotes
1. [http://hashrocket.com/blog/posts/bridging-activerecord-and-mongoid](http://hashrocket.com/blog/posts/bridging-activerecord-and-mongoid)
2. [https://gist.github.com/xuncheng/cf1a0352e7c0d0849072](https://gist.github.com/xuncheng/cf1a0352e7c0d0849072)
3. [https://gist.github.com/jponc/0fbaf4b5aa4ad7cafa9e](https://gist.github.com/jponc/0fbaf4b5aa4ad7cafa9e)
