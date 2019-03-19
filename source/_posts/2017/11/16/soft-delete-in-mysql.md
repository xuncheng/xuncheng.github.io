---
title: 小心 MySQL Soft Delete
categories: Tech
tags:
  - MySQL
---

这是一篇关于一个 MySQL query optimizer 问题的定位及解决。

公司系统中一个简单的 SQL 查询却花费了近 3 秒的时间，语句大致为：

```sql
SELECT slug FROM products
  WHERE id IN (id1, id2, ...)
  AND deleted_at IS NULL;
```

其中，`id` 是 PRIMARY KEY，`deleted_at` 记录删除时间，用于实现 Soft Delete，也加了索引。`deleted_at` 允许为空，为空代表是正常商品，不为空代表“已删除”的商品，同时记录下删除时间。

<!-- more -->

并且在 Rails 的 ActiveRecord 中设置了 `default_scope -> { where(deleted_at: nil) }`。

这条 SQL 语句当然期待一直使用 `PRIMARY` index 实现查询效率最高，但是，结果却出人意料的成了 slow query。

使用 MySQL EXPLAIN 来查看查询的执行流程。结果如下：


发现当给定的 ID 数量个数为 20 左右时，是正常的使用 PRIMARY index；但是，当给定的 ID 数量个数为 50 左右时，竟然使用了 `deleted_at` 为空的有几千万行！

EXPLAIN output 中 Extra 列给出了 `Using index condition`，也就是 MySQL 只使用了 `deleted_at` index 的数据，而不用读取任何表数据；这是 MySQL 的 ICP 优化。这个过程相当于：

- 读取 `deleted_at` 索引信息到内存；
- 找出 `deleted_at` 为空的行的 ID （几千万行）；
- 在上面几千万行中找出 ID 在给定的 ID 列表中的行；

显然，这样效率是极其低下的，出现这种令人意外的行为，我猜测是由于 MySQL 最终获取数据不只一种方式，这就需要评估多种方式执行的复杂度。当指定 ID 比较少时，使用 `PRIMARY` index 这种方式的复杂度相较使用 `deleted_at` index 小；当指定 ID 比较多时，在 MySQL 评估算法中，前一种方式的复杂度竟然诡异地大于后一种方式。而真正执行语句的情况并非如此，让我们先猜测一下该评估算法的一些行为。

- 当指定的 ID 比较多，而且比较离散时，MySQL 认为需要读取更多的 BTree nodes；从 PRIMARY index 中获取到的 ID 后，还要离散的读取表数据，从而过滤 `deleted_at` 为空的行；
- 回头看看使用 `deleted_at` index 这种方式呢，完全只需要使用 index 数据就可以完成；可以很好地利用 ICP 优化，简直完美。

等了解到更多的 MySQL 查询优化后，再补充准确的原因吧。


