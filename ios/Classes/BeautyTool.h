//
//  BeautyTool.h
//  TestBeauty
//
//  Created by lufei on 2019/8/27.
//  Copyright © 2019 leqi. All rights reserved.
//

/// 美颜工具类

#import <UIKit/UIKit.h>
#import "libBeautySDK.h"

NS_ASSUME_NONNULL_BEGIN

/// 美颜级别
typedef struct BeautyLevel {
    double leyelarge;           //左眼放大程度 (0~5)
    double reyelarge;           //右眼放大程度 (0~5)
    double mouthlarge;          //嘴巴缩小程度 (0~5)
    double skinwhite;           //皮肤美白程度 (0~5)
    double skinsoft;            //皮肤美肤程度(去皱纹、祛斑等)(0~5)
    double coseye;              //美瞳程度(0~5)
    double facelift;            // 瘦脸程度
} NJBeautyLevel;

@interface BeautyTool : NSObject

/// 美颜图片-单人 api
+ (UIImage *)beautyImage:(UIImage *)image base64String:(NSString *)baseString beautyLevel:(NJBeautyLevel)beautyLevel;

/// 美颜图片-结婚照 Api
+ (UIImage *)beautyMarriageImage:(UIImage *)image base64String:(NSString *)baseString beautyLevelLeft:(NJBeautyLevel)left beautyLevelRight:(NJBeautyLevel)right;

/// 获取美颜算法版本号
+ (int)getBeautyVersion;

@end

NS_ASSUME_NONNULL_END
