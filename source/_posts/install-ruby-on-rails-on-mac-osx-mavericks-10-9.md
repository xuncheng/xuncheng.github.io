---
title: 'Install Ruby On Rails On Mac OSX Mavericks ( 10.9 )'
categories: Tech
tags:
  - Rails
  - Tools
  - Workflow
date: 2013-12-06
---

### 1. Command Line Tools

``` bash
$ xcode-select --install
```

### 2. Homebrew

``` bash
$ ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
$ brew doctor
```

### 3. RVM

``` bash
$ \curl -sSL https://get.rvm.io | bash
```

### 4. Ruby 1.9.3

``` bash
$ brew install gcc46 # ruby 1.9.3 required
$ rvm install 1.9.3
$ rvm use 1.9.3 --default # ruby 1.9.3 as default
```

### 5. MySQL

``` bash
$ brew install mysql
$ ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
$ launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
```
