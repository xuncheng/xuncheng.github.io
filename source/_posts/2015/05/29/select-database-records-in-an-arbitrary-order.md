---
title: '以任意顺序查询 MySQL 数据库记录'
categories: Tech
tags:
  - Rails
  - MySQL
---

在 Rails 里，你可以很方便的通过一组 ID 从数据库中获取数据:

``` ruby
Note.where(id: [1, 2, 3]).map(&:id)
# => [1, 2, 3]
```

**但如果你希望以一种特定的排序方式返回呢？**比如你先从搜索引擎获得一组ID，那么你如何确保返回的数据跟之前拿到的ID顺序一致呢？

你可以尝试用 `where` 条件去查询:

``` ruby
Note.where(id: [2, 1, 3]).map(&:id)
# => [1, 2, 3]
```

但它并没有按照我们预期的想法去工作。那么你是如何保证你的数据以正确的顺序返回呢？

<!-- more -->

### 使用 MySQL 数据库提供的 FIELD 函数

MySQL 提供了一种 `ORDER BY FILED` 的排序语法:

``` sql
SELECT * FROM `notes` WHERE `notes`.`id` IN (1, 2, 3) ORDER BY FIELD(id, 2, 1, 3)
```

为了方便在项目中使用，可以将它封装一下:

1. 添加 `lib/extensions/active_record/find_by_ordered_fields.rb`

``` ruby
# lib/extensions/active_record/find_by_ordered_fields.rb
module Extensions::ActiveRecord::FindByOrderedFields
  extend ActiveSupport::Concern

  module ClassMethods
    def find_by_ordered(field, values)
      sanitized_field_string = values.present? ? values.map {|v| connection.quote(v)}.join(",") : "''"
      where(field => values).order("FIELD(#{field}, #{sanitized_field_string})")
    end
  end
end

ActiveRecord::Base.send(:include, Extensions::ActiveRecord::FindByOrderedFields)
```

2. 在 `initializer` 里载入 `find_by_ordered_fields` 文件:

``` ruby
# config/initializers/extensions.rb
require File.join(Rails.root, 'lib', 'extensions', 'active_record', 'find_by_ordered_fields')
```

现在你可以直接用 `find_by_ordered` 方法来返回任意顺序的记录了。

``` ruby
# in rails console
Note.find_by_ordered(:id, [2, 1, 3])
```

## Footnotes
1. [How to Select Database Records in an Arbitrary Order](http://www.justinweiss.com/blog/2015/04/20/how-to-select-database-records-in-an-arbitrary-order/)
2. [https://gist.github.com/xuncheng/5328c1548a6515f09a1a](https://gist.github.com/xuncheng/5328c1548a6515f09a1a)
3. [https://github.com/panorama-ed/order_as_specified](https://github.com/panorama-ed/order_as_specified)
