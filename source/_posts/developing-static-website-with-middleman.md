---
title: 'Developing Static Website with Middleman'
categories: Tech
tags:
  - Middleman
  - Wufoo
date: 2013-08-14
---

## [Middleman](http://middlemanapp.com/) - makes developing websites simple ##
Middleman is a static site generator using all the shortcuts and tools in modern web development. [Getting started](http://middlemanapp.com/getting-started/)

### Installation ###

``` bash
$ gem install middleman
```

After installed successfully, it will add one new command to your environment, with 3 useful features:

1. middleman init - starting a new site
2. middleman server - start a local web server running at: `http://localhost:4567/`
3. middleman build - exporting the static site to `build` folder

## [Wufoo](https://www.wufoo.com/) - the online form builder ##
Wufoo is an Internet application that helps anybody build amazing online forms. With Wufoo, you can skip all the hard stuff (because it does it all for you), and start getting things done.

<!-- more -->

### Embed a Wufoo form on your site with XHTML and CSS ###

#### 1. Locating Your Form HTML ####
- Go to the **Code Manager** and download the XHTML/CSS files.
- Open `index.html.erb`(or other file).
- Locate the `action='x'` attribute in the `<form>` tag.
- For `x` we will need to replace the actual URL of your Wufoo form.
- You could find the URL of your form in the **Form Code Manager**, replace and save.

#### 2. Including a POST Key ####
- Go to the **Code Manager** for your form.
- Click on API Information in the top right.
- On the API Information page, locate the POST Key.
- Copy the key into the value attribute of the following markup:

``` html
<input type="hidden" name="idstamp" id="idstamp" value="YourPostKey" />
```

- Copy the entire input element above and place it anywhere inside of the `<form>` tags.

And now we’re all set! You can upload the index file to your website and start submitting data into your Wufoo account.

**ps**: the `name` attribute of **Field** is IMPORTANT!

#### 3. Notification Settings ####
Notification Settings allow you to control the various ways in which you can receive updates about new form submissions.

To configure notification settings for your form, go to the Form Manager and click on “Notifications” underneath the form name.

## Deploying to the Gitcafe Pages ##
Offical blog: [GitCafe正式推出Pages服务](http://blog.gitcafe.com/116.html)

1. Creating a new repository with your `YOUR-USER`
2. Initialize a Git repository
3. Add a html file and commit
4. Add a remote name and create a `gitcafe-pages` branch
5. commit this branch to Gitcafe

``` bash
$ echo 'Hello World' << index.html
$ git init
$ git add .
$ git commit -a -m 'init commit'
$ git remote add origin git@gitcafe.com:YOUR-USER/YOUR-USER.git
$ git checkout -b gitcafe-pages
$ git push origin gitcafe-pages
```

And now we're all set! You can visit `http://YOUR-USER.gitcafe.com/`. 

Custom Domains: [http://blog.gitcafe.com/142.html](http://blog.gitcafe.com/142.html)

``` bash
$ middleman build  # building site
$ cd build
$ middleman deploy  # deploying
```

## Footnotes
1. [http://yedingding.com/2013/04/09/teahourfm-with-middleman.html](http://yedingding.com/2013/04/09/teahourfm-with-middleman.html)
