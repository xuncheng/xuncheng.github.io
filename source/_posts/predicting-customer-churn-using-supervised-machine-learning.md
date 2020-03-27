
---
title: 基于监督式机器学习预测客户流失
mathjax: true
date: 2020-03-26
categories: Machine Learning
tags:
- Spark
  - Machine Learning
---

# 项目背景

对于很多公司而言，用户流失率是一个非常重要的数据，其中付费用户的流失率又更尤为得重要。因此，根据用户过去的行为，预测出可能的流失用户，在用户离开之前提供如优惠等一系列挽留措施，以此来最大限度减少付费用户的流失情况。

在这篇文章中，我将根据 Udacity 提供的数据，在 IBM Waston Studio 云平台上运用 PySpark 来对一家叫 Sparkify 的音乐公司进行付费用户流失的预测。

<!--more-->

## 问题陈述

在项目中，我们将探索收集到的用户交互数据，并运用机器学习记录来找到一些线索，以预测将来哪些用户可能会流失，以便我们进行一些挽留措施来防止潜在的损失。

1. 使用 Spark 读入 Udacity 提供的原始数据
2. 进行数据清理和探索性分析（EDA）
3. 生成特征和标签
4. 使用监督学习进行建模、评估和改进

## 模型衡量指标

下面的插图解释了 `精度（precision）` 和 `召回率（recall）` 指标，`准确率（accuracy）` 指的是正确分类的点占总点数的比例。

![f1\_score][image-1]

在这里我们选择 `F1-score` 作为模型评价指标的首选，因为 `F1-score` 同时考虑了 `precision` 和 `recall` ，具体的计算公式如下：

$$ F\_1=2 ⋅ \frac{Precision\*Recall}{Precision+Recall} $$

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

![][image-2]

# 定义客户流失

在完成初步的数据分析之后，我使用 `Cancellation Confirmation` 事件来定义客户流失，创建一列 `churn` 作为模型的标签，该事件在付费或免费客户身上都有发生。

# 数据可视化

图 1 中，在225个用户中，其中有52个客户流失了，客户流失率达到了23%，这个比例还是比较高的，因此预测这部分用户是很有意义的。

![][image-3]

图 2 展示了非流失用户与流失用户的点赞次数情况。

![][image-4]

图 3 展示了非流失用户与流失用户的点踩次数情况。

![][image-5]

最终我选取了 `gender`，`songsPlayed`，`artistsPlayed`，`thumbsUps`，`thumbsDowns` 等特征作为后续分析建模的一部分。

# 模型选择与结果

基于以上的分析，最终选取了 `churn`，`gender`，`songs`，`thumbs up`，`thumbs down` 和 `artist` 这些变量作为特征工程，其中 `churn` 作为标签。

具体数据字典如下图所示：

![特征工程][image-6]

预测用户流失率，本质上是二分类问题，因此，我选择了 `LogisticRegression`和 `RandomForestClassifier` 两种模型。

## 模型训练

对于逻辑回归，正则化强度的逆用作超参数进行搜索。 此超参数越小，指定的调整越强，它用于惩罚可能导致过度拟合的LR模型的大系数。 `0.0，0.1，0.01` 是要探索的候选对象。 交叉验证后，正则化强度为 `0.01` 时在训练集上获得最高分0.6324，而其相应的在测试集上为0.767。

对于随机森林，`numTrees` 作为超参进行搜索。`10，30` 是要探索的候选对象。交叉验证后，`numTrees` 为 `10` 时在训练集上获得最高分0.572，相应的在测试集上为 0.580。

## 结果
根据最终的训练结果，`LogisticRegression` 模型的效果最好，在测试集中 F1-score 达到了 0.767，因此，可以采用该模型进行预测流失用户。

# 总结

预测流失用户，本质上是针对用户的二分类问题，因此适合采用监督学习的机器学习方法。项目主要流程包括：数据清洗，探索性分析，特征工程，监督学习建模，建模过程中采用F1分数对模型进行评估和改进。

在这个问题上，由于特征较少，所以随机森林算法没有优势，逻辑回归算法表现更好。项目中，可以提取更多的特征，以及更多的参数来对模型进行改进。

## 困难与挑战

- 在一开始处理源数据和提取特征的时候，你可能需要花点时间去研究下数据结构，可能还要去猜测一些各数据的含义；
- 在机器学习算法中获得一个满意的结果也很难。不光需要我们挑选合适的模型，还需要不断去调整算法的参数，以达到我们对预测的一个预期效果。

# 资料
1. [https://github.com/xuncheng/DSND\_Sparkify][1]
2. [https://spark.apache.org/ ][2]
3. [https://dataplatform.cloud.ibm.com/ ][3]

[1]:	https://github.com/xuncheng/DSND_Sparkify
[2]:	https://spark.apache.org/
[3]:	https://dataplatform.cloud.ibm.com/

[image-1]:	/images/predicting-customer-churn-using-supervised-machine-learning/precisionrecall.svg
[image-2]:	/images/predicting-customer-churn-using-supervised-machine-learning/pages.png
[image-3]:	/images/predicting-customer-churn-using-supervised-machine-learning/user-condition.png
[image-4]:	/images/predicting-customer-churn-using-supervised-machine-learning/thumbs-up.png
[image-5]:	/images/predicting-customer-churn-using-supervised-machine-learning/thumbs-down.png
[image-6]:	/images/predicting-customer-churn-using-supervised-machine-learning/features.png