# XDWorkTime
排列上班时间表

## 应用下载

[排班APP下载地址](https://www.pgyer.com/agti)或者扫下面二维码下载

![image](http://oalg33nuc.bkt.clouddn.com/image/QQ20160805-0.png)

由于是企业级证书打包发布，iOS9需要去`设置`-`通用`-`设备管理`里面手动信任打包应用的证书

## 功能介绍

一个工具类小应用。

提供给轮班上班的人们，上班时间不按照周一至周五工作日，周六日休息，有可能两天白班两天夜班三天晚班然后休息两天，然后再循环。周而复始一如既往，不管周六日，哪管黄金周。

还掺杂了其他小功能，天气预报、笑话大全、影讯，调用了`聚合数据`提供的接口。

还有注册、登录、记录事项等功能，使用了`Bmob后端服务`

适配iOS10，添加了窗口小部件widget

|首页|widget|
|:---:|:---:|
|![image](http://oalg33nuc.bkt.clouddn.com/image/Simulator%20Screen%20Shot%202016%E5%B9%B48%E6%9C%885%E6%97%A5%20%E4%B8%8B%E5%8D%885.05.04.png)|![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/WechatIMG94.jpeg?raw=true)|

## 窗口小部件widget的开发

widget是iOS8时推出的窗口小部件功能，窗口小部件在Android上早已大行其道。记得当年用过的第一部Android机是深圳出产的国产机佳域，当时划过三四个屏幕的应用，还能继续划过三四个屏幕的窗口小部件。用的最多的窗口小部件就是日历了，屏幕上一目了然。

Apple直到iOS8才加入窗口小部件，而且可自定义程度远远没有Android开放。

### 创建widget

File -> New -> Target

|:---:|:---:|
|![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/2016-10-094.36.08.png?raw=true)|![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/2016-10-094.40.27.png?raw=true)|


