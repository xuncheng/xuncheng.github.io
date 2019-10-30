---
title: 'Polymorphic Associations in Rails'
categories: Tech
tags:
  - Rails
  - Associations
  - Polymorphic
date: 2013-06-23
---

With polymorphic associations, one class can belong_to more than one type of another class. In other words, this is not polymorphism in the typical object-oriented sense of the word; rather, it is something unique to Rails.

## In the Case of Models with Comments
For example, you might have a `Comment` model that belongs to either `Timesheet` model or `BillableWeek` model.

Here is a migration that will create the `comments` table:

``` ruby
class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :commentabel, polymorphic: true
      # t.integer :commentable_id
      # t.string :commentable_type
      t.timestamps
    end
  end
end
```

<!-- more -->

Here is `Comment`, `Timesheet` and `BillableWeek` models:

``` ruby
class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
end

class Timesheet < ActiveRecord::Base
  has_many :comments, as: :commentable
end

class BillableWeek < ActiveRecord::Base
  has_many :comments, as: :commentable
end
```

### Has_many :through and Polymorphics

``` ruby
class Comment < ActiveRecord::Base
  belongs_to :user # author of the comment
  belongs_to :commentable, polymorphic: true
end

class User < ActiveRecord::Base
  has_many :comments
  # has_many :commentables, through: comments  !# error
  has_many :commented_timesheet, through: comments,
           source: :commentable, source_type: 'Timesheet'
  has_many :commented_billable_weeks, through: comments,
           source: :commentable, source_type: 'BillableWeek'
end
```
