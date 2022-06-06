//
//  ThinkingAnalyticsProxy.h
//  demo iOS
//
//  Created by huangdiao on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThinkingAnalyticsProxy : NSObject

@property (assign) int luaHander;
@property (readonly) NSString *name;

- (void)delay;
+ (NSDictionary *)LuaOCTest:(NSDictionary *)dict;

+ (void)startSDK:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
