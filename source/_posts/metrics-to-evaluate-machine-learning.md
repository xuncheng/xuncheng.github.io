
---
title: '机器学习 - 评估指标'
mathjax: true
date: 2019-10-29

---

1.混淆矩阵

![Confusion Matrix][image-1]

**类型1和类型2错误：**
- 第一类错误/假阳性(False Positive, FP)
- 第二类错误/假阴性(False Negative, FN)

<!--more-->

2.准确率(accuracy)：正确分类的点占总点数的比例。

![Accuracy][image-2]

在 sklearn 中使用 [`accuracy_score`][1] 函数可以很容易地计算准确度：

```python
from sklearn.metrics import accuracy_score
accuracy_score(y_true, y_pred)
```

准确率不适用偏斜严重的数据集，如信用卡欺骗系统模型。

3.精度(precision)：在所有预测为阳性的点中，有多少是真正地阳性？

4.召回率(recall)：在全部被标记为阳性的点中，有多少被正确的诊断出来为阳性？

5.F1得分：精度和召回率的调和平均值，调和平均值总是比算术平均小，接近精度和召回率之中较小的值，具体公式如下：

$$ F1\ Score=2 ⋅ \frac{Precision\*Recall}{Precision+Recall} $$

6.F-Beta 得分

$$ F\_β=(1+β^2)⋅\frac{Precision⋅Recall}{β^2⋅Precision+Recall} $$

其中 β 的界限在 0 和 ∞ 之间：
- 如果 β = 0，则得出**精度**；
- 如果 β = ∞，则得出**召回率**；
- 对于其他值，如果接近 0，则得出接近精度的值，如果很大，则得出接口召回率的值，如果 β = 1，则得出精度和召回率的**调和平均数**。

7.ROC曲线：Receiver Operating Characteristic，受试者工作特征曲线，下面是工作原理：
1. 真阳性比例：在所有阳性标记的点中，有多少点分类正确/所有阳性点；
2. 假阳性比例：在所有阴性标记的点中，有多少点被认为是阳性/所有阴性点；
3. 计算所有可能情况，并记下这些数字(**假阳性比例**, **真阳性比例**)，将这些数字代入平面，得出的曲线，即ROC曲线
得出以下结论：
- 完美数据情况下，ROC曲线下方的面积接近1；
- 良好数据情况下，ROC曲线下方的面积接近0.8；
- 随机数据情况下，ROC曲线下方的面积接近0.5；
- 曲线下的面积可以小于0.5，甚至为0。为0的模型更像是倒退，阳性的区域有更多的阴极点，阴性的区域有更多的阳极点，或许翻转数据会有帮助。

![ROC Curve][image-3]

8.回归指标：用于评估回归模型的指标

a.平均绝对误差：点到线的距离绝对值求和平均值，在 sklearn 中很相关代码：

```python
from sklearn.metrics import mean_absolute_error
from sklearn.linear_model import LinearRegression

classifier = LinearRegression()
classifier.fit(X, y)

guesses = classifier.predict(X)

error = mean_absolute_error(y, guesses)
```

但是平均绝对误差有一个问题，即绝对值函数是不可微分的，这不利于我们使用梯度下降等方法，所以我们使用更常见的均方误差。

b.均方误差：点到线距离的平方求和平均值，sklearn 代码：

```python
from sklearn.metrics import mean_squared_error
from sklearn.linear_model import LinearRegression

classifier = LinearRegresion()
classifier.fit(X, y)

guesses = classifier.predict(X)

error = mean_squared_error(y, guesses)
```

c.R2分数：计算公式如下

$$R2=1-\frac{线性回归均方误差}{最简单均方误差}$$

其中拟合一堆点的最简单的模型是取所有点的平均值，画一条经过该值的水平直线。
结论：模型效果很差，R2分数接近于0，如果模型很好，R2分数接近于1。

在 sklearn 中计算 R2 分数：

```python
from sklearn.metrics import r2_score

y_true = [1, 2, 4]
y_pred = [1.3, 2.5, 3.7]

r2_score(y_true, y_pred)
```

![R2 Score][image-4]

[1]:	https://scikit-learn.org/stable/modules/generated/sklearn.metrics.accuracy_score.html#sklearn.metrics.accuracy_score

[image-1]:	/images/metrics-to-evaluate-machine-learning/confusion_matrix.jpg
[image-2]:	/images/metrics-to-evaluate-machine-learning/accuracy.jpg
[image-3]:	/images/metrics-to-evaluate-machine-learning/roc_curve.jpg
[image-4]:	/images/metrics-to-evaluate-machine-learning/r2_score.jpg
