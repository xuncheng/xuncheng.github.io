---
title: 'Fabrication: Object Generation for Ruby'
categories: Tech
tags:
  - Ruby
  - Fabrication
  - Faker
date: 2013-07-09
---

## Fabrication
Fabrication is a simple and powerful object generation library.
Homepage: [http://www.fabricationgem.org/](http://www.fabricationgem.org/)

Add `fabrication` in the Gemfile

``` ruby
group :development, :test do
  gem "fabrication", "~> 2.7.12"
end
```

Fabricators defind in the right place are automatically loaded, for example: 

``` ruby
spec/fabricators/video_fabricator.rb
```

## Faker
A library for generating fake data such as names, addresses, and phone numbers.
Homepage: https://github.com/stympy/faker

Add `faker` in the Gemfile

``` ruby
group :test do
  gem "faker", "~> 1.1.2"
end
```

**Usage**

``` ruby
Faker::Name.name      #=> "Christophe Bartell"
Faker::Internet.email #=> "kirsten.greenholt@corkeryfisher.info"
```

<!-- more -->

## Fabricating Objects
- `spec/fabriactors/video_fabricator.rb`

``` ruby
Fabricator(:video) {
  title { Faker::Lorem.words(5) }
  description { Faker::Lorem.pargraph(2) }
}
```

if you don't want to persist the object to the database, you can use `Fabricate.build` and skip the save step

``` ruby
Fabricate.build(:video)
```
