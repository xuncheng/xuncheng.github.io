---
title: 'Twitter Bootstrap with Rails'
categories: Tech
tags:
  - Rails
  - Bootstrap
  - CSS
---

### 1. Install the Bootstrap-Sass Gem

Sass is a default for CSS development in Rails so I recommend installing Thomas McDonald’s [bootstrap-sass](https://github.com/thomas-mcdonald/bootstrap-sass) gem.

add `bootstrap-sass` in the **Gemfile**

``` ruby
gem 'bootstrap-sass'
```

and run `$ bundle install`

### 2. Include the Twitter Bootstrap Javascript
Include the twitter bootstrap javascript files by modifying the file **app/assets/javascripts/application.js**

``` js
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
```

### 3. Import the Twitter Bootstrap CSS
adding a new file **app/assets/stylesheets/bootstrap_and_overrides.css.scss file**

``` css
@import "bootstrap";
```

<!-- more -->

### 4. Default Application Layout with Twitter Bootstrap
Twitter Bootstrap provides additional elements for a more complex page layout.

Replace the contents of the file **app/views/layouts/application.html.erb** with this:

ERB version: [https://gist.github.com/xuncheng/5998747](https://gist.github.com/xuncheng/5998747)

{% gist 5998747 %}

HAML version: [https://gist.github.com/xuncheng/5998755](https://gist.github.com/xuncheng/5998755)

{% gist 5998755 %}

### 5. Flash Messages with Twitter Bootstrap
For CSS styling with twitter bootstrap, create a partial for flash messages in **app/views/layouts/_messages.html.erb** like this:

ERB version: [https://gist.github.com/xuncheng/5998767](https://gist.github.com/xuncheng/5998767)

{% gist 5998767 %}

HAML version: [https://gist.github.com/xuncheng/5998779](https://gist.github.com/xuncheng/5998779)

{% gist 5998779 %}
