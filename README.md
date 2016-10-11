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

widget可以理解为一个独立的项目，虽然形式上看来像是附属于app的一部分功能，其实并不是，widget想获取app的数据，还需要做数据共享。

File -> New -> Target

![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/2016-10-094.36.08.png?raw=true)

选择iOS里的Today Extension

![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/2016-10-094.40.27.png?raw=true)

习惯使用纯代码布局，喜欢用storyboard的略过。在新创建的widget项目文件夹中删除MainInterface.storyboard，修改info.plist如下内容

![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/QQ20161009-0.png?raw=true)

确定将原来的key-value:`NSExtensionMainStoryboard` `MainInterface`修改为`NSExtensionPrincipalClass` `TodayViewController`。`TodayViewController`是自定义的控制器名字。

### widget折叠

iOS10之后才有的widget折叠。

```Objective-C
#ifdef __IPHONE_10_0
    //需要折叠
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
#endif
```

实现下面方法。

```Objective-C
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 400);
    }
}
```

### 点击widget开启app

在app的`TARGEST`里的`info`下`URL Types`添加`URL Schemes`

![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/QQ20161009-1.png?raw=true)

widget上显示的自定义view：`_calendarView`，给`_calendarView`添加触摸事件。

```Objective-C
UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openApp)];
[_calendarView addGestureRecognizer:tap];
```

实现触摸事件，开启app

```Objective-C
- (void)openApp {
    [self.extensionContext openURL:[NSURL URLWithString:@"paibanapp://"] completionHandler:^(BOOL success) {
        NSLog(@"successs = %d", success);
    }];
}
```

### 数据共享

创建App Groups的Identifiers。在创建证书的时候勾选App Groups，设置创建的App Groups

![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/QQ20161009-3.png?raw=true)

在Xcode的`TARGEST` -> `Capabilities`里打开App Groups。

![img](https://github.com/mxdios/notebook/blob/master/notebooks/images/QQ20161009-2.png?raw=true)

#### 用NSUserDefaults共享数据，

存储数据

```Objective-C
NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.xxxx"];//App Groups ID
[shared setObject:[NSDictionary dictionaryWithObjectsAndKeys:dutyArray, @"dutyArrayKey", selectDayStr, @"selectDayStrKey", tags, @"selectTagArrayKey", nil] forKey:@"todayViewShared"];
[shared synchronize];
```

读取数据

```Objective-C
NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.xxxx"];//App Groups ID
NSDictionary *dict = [NSDictionary dictionaryWithDictionary:[shared objectForKey:@"todayViewShared"]];
```

#### 用NSFileManager共享数据

存储数据

```Objective-C
NSError *err = nil;
NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.xxxx"];//App Groups ID
containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/widget"];
NSDictionary *value = [NSDictionary dictionaryWithObjectsAndKeys:dutyArray, @"dutyArrayKey", selectDayStr, @"selectDayStrKey", tags, @"selectTagArrayKey", nil];
BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
if (!result) {
	NSLog(@"%@",err);
} else {
	NSLog(@"save value:%@ success.",value);
}
```

读取数据

```Objective-C
NSError *err = nil;
NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.xxxx"];//App Groups ID
containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/widget"];
NSString *value = [NSString stringWithContentsOfURL:containerURL encoding: NSUTF8StringEncoding error:&err];
```

