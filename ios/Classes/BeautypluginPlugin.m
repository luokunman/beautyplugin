#import "BeautypluginPlugin.h"
#import "BeautyTool.h"

@implementation BeautypluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"beautyplugin"
            binaryMessenger:[registrar messenger]];
  BeautypluginPlugin* instance = [[BeautypluginPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"beauty" isEqualToString:call.method]) {
        NSDictionary *dic = call.arguments;
        NSString *base64String = dic[@"faceInfo"];

        FlutterStandardTypedData *myData = dic[@"image"];
        UIImage *image = [UIImage imageWithData:myData.data];

        NSDictionary<NSString *, NSNumber *> *beautyLevel = dic[@"fairLevel"];

        NJBeautyLevel level = {[beautyLevel[@"leyelarge"] intValue], [beautyLevel[@"reyelarge"] intValue], [beautyLevel[@"mouthlarge"] intValue], [beautyLevel[@"skinwhite"] intValue], [beautyLevel[@"skinsoft"] intValue], [beautyLevel[@"coseye"] intValue], [beautyLevel[@"facelift"] intValue]};

        UIImage *end = [BeautyTool beautyImage:image base64String:base64String beautyLevel:level];

        NSData *data = UIImagePNGRepresentation(end);

        result([FlutterStandardTypedData typedDataWithBytes:data]);
    } else if ([@"version" isEqualToString:call.method]) {
        result(@([BeautyTool getBeautyVersion]));
    } else {
      result(FlutterMethodNotImplemented);
    }
}

@end
