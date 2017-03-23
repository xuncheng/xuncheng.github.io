---
title: 'Testing: RSpec and Shoulda-Matchers'
categories: Tech
tags:
  - Testing
  - RSpec
  - Shoulda-Matchers
---

## Rspec
Homepage: [https://github.com/rspec/rspec-rails](https://github.com/rspec/rspec-rails)

Add `rspec-rails` to **both** the `:development` and `:test` groups in the `Gemfile`

``` ruby
group :development, :test do
  gem 'rspec-rails', '~> 2.0'
end
```

Download and install by running: 

``` bash
$ bundle install
```

Initialize the `spec/` directory (where specs will reside) with: 

``` bash
$ rails generate rspec:install
```

**Model specs**

``` ruby
require 'spec_helper'

describe Video do
  it "saves itself" do
    video = Video.new(title: "monk", description: "a great video!")
    video.save
    expect(Video.first).to eq(video)
  end

  it "belongs to category" do
    dramas = Category.create(name: "dramas")
    monk = Video.create(title: "monk", description: "a great video!", category: dramas)
    expect(monk.category).to eq(dramas)
  end
  
  it "does not save a video without a title" do
    expect(Video.new(title: nil)).to have(1).errors_on(:title)
  end
end
```

before run `rspec`, you SHOULD prepare test database:

``` bash
$ rake db:migrate db:test:prepare
$ rspec # Make sure prepare test database before run rspec!!!
```

<!-- more -->

## Shoulda-Matchers
Homepage: [https://github.com/thoughtbot/shoulda-matchers](https://github.com/thoughtbot/shoulda-matchers)

Add `shoulda-matchers` to the `:test` groups in the `Gemfile`:

``` ruby
group :test do
  gem 'shoulda-matchers', '~> 2.2.0'
end
```

rewrite rspec testing with shoulda-matchers

``` ruby
require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { validate_presence_of(:title) }
end
```
