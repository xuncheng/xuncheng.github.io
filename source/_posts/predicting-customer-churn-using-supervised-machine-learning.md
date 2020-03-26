
---
title: 基于监督式机器学习预测客户流失
mathjax: true
date: 2020-03-26
categories: Machine Learning
tags:
- Spark
- 
  - Machine Learning
---

对于很多公司而言，用户流失率是一个非常重要的数据，其中付费用户的流失率又更尤为得重要。因此，根据用户过去的行为，预测出可能的流失用户，在用户离开之前提供如优惠等一系列挽留措施，以此来最大限度减少付费用户的流失情况。

在这篇文章中，我将根据 Udacity 提供的数据，在 IBM Waston Studio 云平台上运用 PySpark 来对一家叫 Sparkify 的音乐公司进行付费用户流失的预测。

<!--more-->

# 数据集

完整的数据集大小约 12GB，由于时间和计算条件的限制，我选取了它的一个迷你子集，大小约一百兆，其中包含了225个用户的278,154条行为。数据集的结构如下：

| 列名 | 解释 |
| ---- | ---- |
| artist | 演唱者
| auth  | 验证信息
| firstName |  名
| gender | 性别
| itemInSession | 会话
| lastName | 姓
| length | 时间
| level | 用户等级
| location | 地区
| method | 请求方法
| page | 用户行为
| registration | 是否
| sessionId | 会话ID
| song | 歌曲名
| status | HTTP请求状态
| ts | 时间戳
| userAgent | HTTP代理
| userId | 用户ID

这里我们在详细观察下 `page` 的数据，`page` 记录了用户的行为，完整的行为如下：

![][image-1]

# 定义客户流失

在完成初步的数据分析之后，我使用 `Cancellation Confirmation` 事件来定义客户流失，创建一列 `churn` 作为模型的标签，该事件在付费或免费客户身上都有发生。

# 数据可视化

图 1 中，在225个用户中，其中有52个客户流失了，客户流失率达到了23%，这个比例还是比较高的，因此预测这部分用户是很有意义的。

![][image-2]

图 2 展示了非流失用户与流失用户的点赞次数情况。

![][image-3]

图 3 展示了非流失用户与流失用户的点踩次数情况。

![][image-4]

最终我选取了 `gender`，`songsPlayed`，`artistsPlayed`，`thumbsUps`，`thumbsDowns` 等特征作为后续分析建模的一部分。

# 模型选择与结果

基于以上的分析，最终选取了 `churn`，`gender`，`songs`，`thumbs up`，`thumbs down` 和 `artist` 这些变量作为特征工程，其中 `churn` 作为标签。

 预测用户流失率，本质上是二分类问题，因此，我选择了 `LogisticRegression`和 `RandomForestClassifier` 两种模型，其中 `LogisticRegression` 模型的效果最好，在测试集中 F1\_score 达到了 0.767，因此，可以采用该模型进行预测流失用户。

# 总结与反思

预测流失用户，本质上是针对用户的二分类问题，因此适合采用监督学习的机器学习方法。项目主要流程包括：数据清洗，探索性分析，特征工程，监督学习建模，建模过程中采用F1分数对模型进行评估和改进。

在这个问题上，由于特征较少，所以随机森林算法没有优势，逻辑回归算法表现更好。项目中，可以提取更多的特征，以及更多的参数来对模型进行改进。

一开始计划之后修改原始数据来进行建模，思考后改成了用包含特征属性的新数据集来进行建模；最好不要破解原始数据，这样可以尝试多次提取不同的特征来进行建模。

# 源码和资料
1. [https://github.com/xuncheng/DSND\_Sparkify][1]
2. [https://spark.apache.org/ ][2]
3. [https://dataplatform.cloud.ibm.com/ ][3]

[1]:	https://github.com/xuncheng/DSND_Sparkify
[2]:	https://spark.apache.org/
[3]:	https://dataplatform.cloud.ibm.com/

[image-1]:	/images/predicting-customer-churn-using-supervised-machine-learning/pages.png
[image-2]:	/images/predicting-customer-churn-using-supervised-machine-learning/user-condition.png
[image-3]:	/images/predicting-customer-churn-using-supervised-machine-learning/thumbs-up.png
[image-4]:	/images/predicting-customer-churn-using-supervised-machine-learning/thumbs-down.png