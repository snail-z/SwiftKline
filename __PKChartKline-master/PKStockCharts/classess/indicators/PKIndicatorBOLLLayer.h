//
//  PKIndicatorBOLLLayer.h
//  PKChartKit
//
//  Created by zhanghao on 2017/12/16.
//  Copyright © 2017年 PsychokinesisTeam. All rights reserved.
//

#import "PKIndicatorBaseLayer.h"

NS_ASSUME_NONNULL_BEGIN

/// 主图区域布林线
@interface PKIndicatorBOLL1Layer : PKIndicatorBaseLayer <PKIndicatorMajorProtocol>

@end

/// 副图区域布林线
@interface PKIndicatorBOLLLayer : PKIndicatorBaseLayer <PKIndicatorMinorProtocol>

@end

NS_ASSUME_NONNULL_END
