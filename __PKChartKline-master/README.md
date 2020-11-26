

# PKStockChart

一款使用简单快速、高性能的股票图表库，包括K线图分时图，支持外观样式自定义，支持叠加绘制图表。

## 分时图表PKTimeChart

- **如何自定义网格中时间分隔线？**

  其中PKTimeChartSet有两个属性，分别是`timeSharingSets`和`timelinePoints`，它们必须配合使用才能自定义任何时间点线。默认这个两个属性为空值，内部均分网格线。`dateTimeTexts`是用于你网格中实际显示的文本

  你可以通过NSDate分类中的方法

  `+ (NSArray<NSString *> *)pk_timeSharingSets:(NSString *)begin end:(NSString *)end;`

  来获取某时间段的分钟集。

  如下，自定义科创板中时间点线，分别为9:30/11:30/15:05/15:30这个四个点要显示文本，10:30和14:30不显示，但需要画线。操作如下

  ```objc
  // 1.设置数据量，画线的点数
  set.maxDataCount = 267;
  
  // 2.制作267个时间点，对应你的后台数据每个时间点
  NSMutableArray *timeSets = [NSMutableArray array];
  NSArray *a1 = [NSDate pk_timeSharingSets:@"09:30" end:@"11:30"]; //获取该时间段的分钟点
  NSArray *a2 = [NSDate pk_timeSharingSets:@"13:00" end:@"15:00"];
  NSArray *a3 = [NSDate pk_timeSharingSets:@"15:05" end:@"15:30"];
  [timeSets addObjectsFromArray:a1];
  [timeSets addObjectsFromArray:a2];
  [timeSets addObjectsFromArray:a3];
  set.timeSharingSets = timeSets; 
  
  // 3.设置你要画线的时间点，时间格式要和数组points中对应，可以自定义任何时间点
  set.timelinePoints = @[@"09:30", @"10:30", @"11:30", @"14:00", @"15:00", @"15:30"];
  
  // 4.设置你实际要显示的时间文本，数组个数需要和timelinePoints相同，不显示的用null代替
  set.dateTimeTexts = @[@"09:30", [NSNull null], @"11:30/13:00", [NSNull null], @"15:05", @"15:30"];
  ```

  

## K线图表PKKLineChart

* 如何自定义指标视图？

  PKKLineChart外部方法`registerClass:forIndicatorIdentifier:`是注册自定义指标使用，如下：

  ```objc
  // 主图区域注册MA指标
  NSArray *majorIndicators = @[PKIndicatorMA];
  for (NSString *identifier in majorIndicators) {
  	[_KlineChart registerClass:NSClassFromString(identifier) forIndicatorIdentifier:identifier];
  }
  
  // 副图区域注册的指标集合
  NSArray *minorIndicators = @[PKIndicatorVOL, PKIndicatorBOLL, PKIndicatorMACD, PKIndicatorKDJ];
  for (NSString *identifier in minorIndicators) {
  	[_KlineChart registerClass:NSClassFromString(identifier) forIndicatorIdentifier:identifier];
  }
  
  // 设置默认显示的指标
  _KlineChart.defaultMajorIndicatorIdentifier = PKIndicatorMA;
  _KlineChart.defaultMinorIndicatorIdentifier = PKIndicatorVOL;
  ```

  

### 效果预览

**五日分时图**

<img src="https://github.com/PsychokinesisTeam/PKStockCharts/blob/master/Resources/005.png?raw=true" width="500px" height="265px">

<img src="https://github.com/PsychokinesisTeam/PKStockCharts/blob/master/Resources/004.png?raw=true" width="500px" height="265px">

**K线指标图**

<img src="https://github.com/PsychokinesisTeam/PKStockCharts/blob/master/Resources/001.png?raw=true" width="500px" height="265px">

<img src="https://github.com/PsychokinesisTeam/PKStockCharts/blob/master/Resources/002.png?raw=true" width="500px" height="265px">
