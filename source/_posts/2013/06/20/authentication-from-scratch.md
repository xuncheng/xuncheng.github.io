---
title: 'Authentication from Scratch'
categories: Tech
tags:
  - Rails
  - Authentication
---

Simple password authentication is easy to do with `has_secure_password`. Here you will learn how to make a complete Sign Up, Log In, and Log Out process as well as restrict access to certain actions.

## 1. User model

### 1.1 database migrations

``` bash
$ rails g migration create_users
```

``` ruby
class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :remember_token
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
```

### 1.2 the model file

``` ruby
class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :remember_token
  has_secure_password

  before_save { email: downcase! }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: ture, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false}
  validates :name, presence: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  after_validates { self.errors.messages.delete(:password_digest) }

  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
```

<!-- more -->

## 2. User register form(2 ways)
**2.1 Using From Builder & Helpers**

- `app/helpers/my_form_builder.rb`

``` ruby
class MyFormBuilder < ActionView::Helpers::FromBuilder
  def label(method, text = nil, options = {}, &block)
    errors = object.errors[method.to_sym]
    if errors
      text += " <span class=\"error\">#{errors.first}</span>"
    end
    super(method, text.html_safe, options, &block)
  end
end
```

- `/app/helpers/application_helper.rb`

``` ruby
module ApplicationHelper
  def my_form_for(record, options = {}, &proc)
    form_for(record, options.merge!({builder: MyFromBuilder}), &proc)
  end
end
```

- `app/views/users/new.html.haml`

``` haml
= my_form_for @user do |f|
  = f.label :full_name, "Full Name"
  = f.text_field :full_name
  = f.label :email, "Email Address"
  = f.email_field :email
  = f.label :password
  = f.password_field :password
  = f.label :password_confirmation, "Confirm Password"
  = f.passwod_field :password_confirmation
  %br
  = f.submit "Create User"
```

**2.2 Using bootstrap_form**
Add `bootstrap_form` in Gemfile

``` ruby
gem 'bootstrap_form'
```

- `app/views/users/new.html.haml`

``` haml
= bootstrap_form(@user, html: {class: 'form-horizontal'}) do |f|
  = f.text_field :full_name, label: 'Fulle Name'
  = f.email_field :email, label: 'Email Address'
  = f.password_field :password
  = f.password_field :password_field, label: 'Confirm Password'
  = f.actions do
    = f.primary 'Create User'
```

## 3. Users resources
- `config/routes.rb`

``` ruby
MyFlix::Application.routes.draw do
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  get '/register', to: "users#new"
  get '/signin', to: "sessions#new"
  match '/signout', to: "sessions#destroy", via: :delete
end
```

## 4. User signin and signout
- 4.1 `app/views/sessions/new.html.haml`

``` haml
= bootstrap_form_for(:session, url: sessions_path) do |f|
  = f.email_field :email, label: 'Email Address'
  = f.password_field :password
  = f.actions do
    = f.primary 'Sign in'
```

- 4.2 `app/controllers/sessions_controller.rb`

``` ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user # user sign in
      redirect_to home_path
    else
      render 'new'
    end
  end

  def destroy
    sign_out # user sign out
    redirect_to root_path
  end
end
```

- 4.3 `app/helpers/sessions_helper.rb`

``` ruby
module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !!current_user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user # check user need sign in
    unless signed_in?
      flash[:error] = "Please sign in."
      redirect_to signin_path
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
```

- 4.4 Including `SessionsHelper` module into the Application controller

``` ruby
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
end
```
