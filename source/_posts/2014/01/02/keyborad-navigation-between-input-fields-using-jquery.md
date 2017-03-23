---
title: 'Keyboard Navigation Between Input Fields Using jQuery'
categories: Tech
tags:
  - JavaScript
  - jQuery
---

这里有一个 form 表单，表单里包含多个 `input fields`，使用 jQuery 可以简单的实现 keyboard navigation。 这意味着，如果用户光标定位在1st input field，然后按下『向下键』(down key)，光标应该跳转到下一个 input field。

为了实现这个功能，这个我们需要定义两个 Helper 方法，功能分别是找到下一个和上一个给定的 `element`：

{% gist 8219581 %}

<!-- more -->

现在我们可以给 `input fields` 添加 `Keyboard Navigation` 功能了，我们需要添加下面一段 js 代码到 `jQuery(document).ready`

{% gist 8219600 %}

现在，我们就可以使用键盘的上/下键来移动`form`表单的 `input fields` 了。

如果你还想在按下 `enter` 键，跳转到下一个 `input` field，很简单：

{% gist 8219632 %}

## Footnotes
1. [http://andreas.haufler.info/2012/02/keyboard-navigation-between-input.html](http://andreas.haufler.info/2012/02/keyboard-navigation-between-input.html)
