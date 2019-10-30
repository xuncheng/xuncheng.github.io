---
title: 'Feature specs in RSpec'
categories: Tech
tags:
  - Rails
  - RSpec
date: 2013-07-22
---

So far we've spent *a lot of* time going over controller and model testing, and use **fabrication** to generate test data. Now it's time to put everything together for ingegration testing-in other words, makding sure thoes models and controllers all play nicely with other models and controllers in the application. These tests are called *feature specs* in RSpec. 

A feature spec covers more ground, and represents how actual users will interact with your code. We write feature specs with *Cypybara*, an extremely useful Ruby library to help define steps of a feature spec and simulate real-world use of your application.

## Add additional gems
add `cypybara` and `launchy` in the **Gemfile**

``` ruby
group :test do
  gem "faker", "~> 1.1.2"
  gem "capybara", "~> 2.1.0"
  gem "launchy", "~> 2.2.0"
end
```

and run `$ bundle install`

## A basic feature spec
Capybara lets you simulate how a user would interact with your application throgh a web browser, using a series of easy-to-understand methods like **click_link**, **fill_in**, and **visit**. These methods let you to descirbe a test scenario for your app.

add a new file **app/spec/features/user\_sign\_in_spec.rb**

``` ruby
require 'spec_helper'

feature "User sign in" do
  scenario "with registered user" do
    user = Fabricate(:user)
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Sign in successfully."
    expect(page).to have_content user.full_name
  end
end
```

<!-- more -->

## A more complicated feature spec
1. refactor `user_sign_in` feature spec using *macros*

define `sign_in` method (in **app/spec/support/macros.rb** file)

Gist: [https://gist.github.com/xuncheng/6051655](https://gist.github.com/xuncheng/6051655)

{% gist 6051655 %}

add a new file **app/spec/features/user\_interact\_with\_queue_spec.rb**

Gist: [https://gist.github.com/xuncheng/6051661](https://gist.github.com/xuncheng/6051661)

{% gist 6051661 %}

## Footnotes
1. [https://github.com/jnicklas/capybara](https://github.com/jnicklas/capybara)
2. [http://railscasts.com/episodes/257-request-specs-and-capybara](http://railscasts.com/episodes/257-request-specs-and-capybara)
3. [https://www.relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec](https://www.relishapp.com/rspec/rspec-rails/docs/feature-specs/feature-spec)
4. [https://www.relishapp.com/rspec/rspec-rails/v/2-13/docs/request-specs/request-speec](https://www.relishapp.com/rspec/rspec-rails/v/2-13/docs/request-specs/request-speec)
5. [http://www.w3schools.com/xpath/xpath_syntaxx.asp](http://www.w3schools.com/xpath/xpath_syntaxx.asp)
