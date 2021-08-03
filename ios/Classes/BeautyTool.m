//
//  BeautyTool.m
//  TestBeauty
//
//  Created by lufei on 2019/8/27.
//  Copyright © 2019 leqi. All rights reserved.
//

#import "BeautyTool.h"
#include "libBeautySDK.h"

@implementation BeautyTool

/// 获取美颜算法版本号
+ (int)getBeautyVersion {
    
    return LQ_FB_GetVersion();
    
}

/// 美颜图片-结婚照 Api
+ (UIImage *)beautyMarriageImage:(UIImage *)image base64String:(NSString *)baseString beautyLevelLeft:(NJBeautyLevel)left beautyLevelRight:(NJBeautyLevel)right {
    
    NSData *plainData = [[NSData alloc] initWithBase64EncodedString:baseString options:0];
    
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    unsigned char *bgr = [self getBGRWithImage:imageRef];

    unsigned char *a = [self getAlphaWithImage:imageRef];
    
    /// 美颜级别 左边
    FBLevel beautyLeft;
    beautyLeft.leyelarge = left.leyelarge;
    beautyLeft.reyelarge = left.reyelarge;
    beautyLeft.mouthlarge = left.mouthlarge;
    beautyLeft.skinwhite = left.skinwhite;
    beautyLeft.skinsoft = left.skinsoft;
    beautyLeft.facelift = left.facelift;
    beautyLeft.coseye = left.coseye;
    
    /// 美颜级别 右边
    FBLevel beautyRight;
    beautyRight.leyelarge = right.leyelarge;
    beautyRight.reyelarge = right.reyelarge;
    beautyRight.mouthlarge = right.mouthlarge;
    beautyRight.skinwhite = right.skinwhite;
    beautyRight.skinsoft = right.skinsoft;
    beautyRight.facelift = right.facelift;
    beautyRight.coseye = right.coseye;
    
    FBLevel arr[2] = {beautyLeft, beautyRight};
        
    int stateCode = LQ_FB_DoFaceBeauty((int)height, (int)width, arr, plainData.bytes, a, bgr);
    
    if (stateCode != 0) {

        free(bgr);
        free(a);

        return nil;

    }
    
    unsigned char * resultRawData = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));

    for (NSUInteger i = 0; i < width * height; i ++) {

        NSUInteger bgrByteIndex = i * 3;
        NSUInteger newByteIndex = i * 4;

        int b = bgr[bgrByteIndex + 0];
        int g = bgr[bgrByteIndex + 1];
        int r = bgr[bgrByteIndex + 2];
        int alpha = a[i];
        
        resultRawData[newByteIndex + 0] = 255 * (r/255.0 * alpha/255.0);
        resultRawData[newByteIndex + 1] = 255 * (g/255.0 * alpha/255.0);
        resultRawData[newByteIndex + 2] = 255 * (b/255.0 * alpha/255.0);
        resultRawData[newByteIndex + 3] = alpha;
        
    }
    
    UIImage *result = [self getImageFromRGBA:resultRawData size:width * height * 4 * sizeof(unsigned char) width:(int)width height:(int)height];
    
    free(bgr);
    free(a);

    return result;
    
}

/// 美颜图片
+ (UIImage *)beautyImage:(UIImage *)image base64String:(NSString *)baseString beautyLevel:(NJBeautyLevel)beautyLevel{
    
    NSData *plainData = [[NSData alloc] initWithBase64EncodedString:baseString options:0];
    
    CGImageRef imageRef = image.CGImage;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    unsigned char *bgr = [self getBGRWithImage:imageRef];

    unsigned char *a = [self getAlphaWithImage:imageRef];
    
    /// 美颜级别
    FBLevel level;
    level.leyelarge = beautyLevel.leyelarge;
    level.reyelarge = beautyLevel.reyelarge;
    level.mouthlarge = beautyLevel.mouthlarge;
    level.skinwhite = beautyLevel.skinwhite;
    level.skinsoft = beautyLevel.skinsoft;
    level.facelift = beautyLevel.facelift;
    level.coseye = beautyLevel.coseye;    
    
    int stateCode = LQ_FB_DoFaceBeauty((int)height, (int)width, &level, plainData.bytes, a, bgr);
    
    if (stateCode != 0) {

        free(bgr);
        free(a);

        return nil;

    }
    
    unsigned char * resultRawData = (unsigned char *)malloc(width * height * 4 * sizeof(unsigned char));

    for (NSUInteger i = 0; i < width * height; i ++) {

        NSUInteger bgrByteIndex = i * 3;
        NSUInteger newByteIndex = i * 4;

        int b = bgr[bgrByteIndex + 0];
        int g = bgr[bgrByteIndex + 1];
        int r = bgr[bgrByteIndex + 2];
        int alpha = a[i];
        
        resultRawData[newByteIndex + 0] = 255 * (r/255.0 * alpha/255.0);
        resultRawData[newByteIndex + 1] = 255 * (g/255.0 * alpha/255.0);
        resultRawData[newByteIndex + 2] = 255 * (b/255.0 * alpha/255.0);
        resultRawData[newByteIndex + 3] = alpha;
        
    }
    
    UIImage *result = [self getImageFromRGBA:resultRawData size:width * height * 4 * sizeof(unsigned char) width:(int)width height:(int)height];
    
    free(bgr);
    free(a);

    return result;
    
}

/// 清理内存
static void FreeImageData(void *info, const void *data, size_t size) {
    free((void *)data);
}

+ (UIImage *)getImageFromRGBA:(unsigned char *)rgba size:(size_t)size width:(int)width height:(int)height
{
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rgba, size, FreeImageData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    size_t components = 4;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    size_t bytesPerRow = components * width;
    CGImageRef imageRef = CGImageCreate(width, height, 8, components * 8, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, YES, renderingIntent);
    
    /// 清理
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    
    return [self reDraw:imageRef];
    
}

/// 重绘
+ (UIImage *)reDraw:(CGImageRef)imageRef
{
    
    size_t canvasWidth = CGImageGetWidth(imageRef);
    size_t canvasHeight = CGImageGetHeight(imageRef);
    CGBitmapInfo bitmapInfo;
    bitmapInfo = kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast;
    
    CGContextRef canvas = CGBitmapContextCreate(NULL, canvasWidth, canvasHeight, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
    if (!canvas) {
        return nil;
    }
    
    // 画CGImage上去
    CGContextDrawImage(canvas, CGRectMake(0, 0, canvasWidth, canvasHeight), imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(canvas);
    
    UIImage *finalImage = [UIImage imageWithCGImage:newImageRef];
    
    // 各种清理，省略
    CGImageRelease(imageRef);
    CGImageRelease(newImageRef);
    CGContextRelease(canvas);
    
    return finalImage;
    
}


/// 获得BGR数据
+ (unsigned char *)getBGRWithImage:(CGImageRef)imageRef
{
    int RGBA = 4;
    int RGB  = 3;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    unsigned char *result = (unsigned char *) malloc(width * height * sizeof(unsigned char) * RGB);
    
    unsigned char *rawData = [self getRGBAWithImage:[UIImage imageWithCGImage:imageRef]];
    
    for (int i = 0; i < width * height; i ++) {
        
        NSUInteger byteIndex = i * RGBA;
        NSUInteger newBGRByteIndex = i * RGB;
        
        int alpha = rawData[byteIndex + 3];
        int red, green, blue;
        CGFloat mA = alpha/255.0;
        
        if (alpha == 0) {
            
            red = 0;
            green = 0;
            blue = 0;
            
        } else {
            
            red    = rawData[byteIndex + 0]/mA;
            green  = rawData[byteIndex + 1]/mA;
            blue   = rawData[byteIndex + 2]/mA;
            
        }
        
        result[newBGRByteIndex + 0] = blue;   // B
        result[newBGRByteIndex + 1] = green;  // G
        result[newBGRByteIndex + 2] = red;    // R
        
    }
    
    free(rawData);
    
    return result;
}

/// 获得alpha数据
+ (unsigned char *)getAlphaWithImage:(CGImageRef)imageRef
{
    int RGBA = 4;
    int alpha = 1;
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    unsigned char *result = (unsigned char *) malloc(width * height * sizeof(unsigned char) * alpha);
    
    unsigned char *rawData = [self getImagePixel:imageRef];
    
    for (int i = 0; i < width * height; i ++) {
        
        NSUInteger byteIndex = i * RGBA;
        NSUInteger newAByteIndex = i;
        
        int alpha  = rawData[byteIndex + 3];
        
        result[newAByteIndex] = alpha;
        
    }
    
    free(rawData);
    
    return result;
}

+ (unsigned char *)getImagePixel:(CGImageRef)imageRef
{
    
    CGDataProviderRef dataProviderRef = CGImageGetDataProvider(imageRef);
    CFDataRef pixelData = CGDataProviderCopyData(dataProviderRef);
    const uint8_t* data = CFDataGetBytePtr(pixelData);
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    uint8_t *imgData = (uint8_t *)malloc(width * height * 4 * sizeof(unsigned char));
    memcpy(imgData, data, width*height * 4 * sizeof(unsigned char));
    
    /// 清理
    CFRelease(pixelData);
    data = NULL;
    
    return imgData;
    
}

+ (unsigned char *)getRGBAWithImage:(UIImage *)image
{
    int RGBA = 4;
    
    CGImageRef imageRef = [image CGImage];
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *) malloc(width * height * sizeof(unsigned char) * RGBA);
    NSUInteger bytesPerPixel = RGBA;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    return rawData;
}

@end
