//
//  TDAnalyticsProxy.m
//  demo iOS
//
//  Created by huangdiao on 2022/3/10.
//

#import "TDAnalyticsProxy.h"
#include "platform/ios/CCLuaObjcBridge.h"
#import <ThinkingSDK/ThinkingAnalyticsSDK.h>

@interface TDAnalyticsProxy ()

@end

@implementation TDAnalyticsProxy

// /* ========== begin of singleton ===========  */
// __strong static TDAnalyticsProxy *_singleton = nil;

// + (id)allocWithZone:(NSZone *)zone
// {
//     return [self sharedInstance];
// }

// + (TDAnalyticsProxy *)sharedInstance
// {
//     static dispatch_once_t pred = 0;
//     dispatch_once(&pred, ^{
//         _singleton = [[super allocWithZone:NULL] init];
//     });
//     return _singleton;
// }

// - (id)copyWithZone:(NSZone *)zone
// {
//     return self;
// }

// /* ========== end of singleton ===========  */

// - (instancetype)init
// {
//     self = [super init];
//     if (self) {
//         _name = @"TDAnalyticsProxy";
//         _luaHander = -1;
//     }
//     return self;
// }

// - (void)delay
// {
//     cocos2d::LuaObjcBridge::pushLuaFunctionById(self.luaHander);
//     cocos2d::LuaValueDict item;
//     item["str"] = cocos2d::LuaValue::stringValue("hello");
//     item["int"] = cocos2d::LuaValue::intValue(1000);
//     item["bool"] = cocos2d::LuaValue::booleanValue(TRUE);
//     cocos2d::LuaObjcBridge::getStack()->pushLuaValueDict(item);
//     cocos2d::LuaObjcBridge::getStack()->executeFunction(1);

//     cocos2d::LuaObjcBridge::releaseLuaFunctionById(self.luaHander);
// }

// + (NSDictionary *)LuaOCTest:(NSDictionary *)dict
// {
//     if ([dict objectForKey:@"cb"]) {
//         [TDAnalyticsProxy sharedInstance].luaHander = [[dict objectForKey:@"cb"] intValue];
//     }

//     [[TDAnalyticsProxy sharedInstance] performSelector:@selector(delay) withObject:nil afterDelay:2];

//     return [NSDictionary dictionaryWithObjectsAndKeys:
//             [TDAnalyticsProxy sharedInstance].name, @"name",
//             [NSNumber numberWithInt:[TDAnalyticsProxy sharedInstance].luaHander], @"luaHander",
//             nil];
// }

// static NSString * APP_ID = @"22e445595b0f42bd8c5fe35bc44b88d6";
// static NSString * SERVER_URL = @"https://receiver-ta-dev.thinkingdata.cn";

// + (void)startSDK:(NSDictionary *)data {
    
//     [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelDebug];
//     ThinkingAnalyticsSDK *instance = [ThinkingAnalyticsSDK startWithAppId:APP_ID withUrl:SERVER_URL];
    
//     [instance track:@"test_event"];
// }

+ (void)setCustomerLibInfo:(NSDictionary *)params {
    NSString *name = params[@"name"];
    NSString *version = params[@"version"];
    [ThinkingAnalyticsSDK setCustomerLibInfoWithLibName:name libVersion:version];
}

/*
 {
    appId: "Your_App_Id",
    serverUrl: "Your_Server_Url",
    debugModel: off=0 debugOnly=1 debug=2,
 }
 */
+ (void)sharedInstance:(NSDictionary *)params {
    NSString *appId = params[@"appId"];
    NSString *serverUrl = params[@"serverUrl"];
    TDConfig *config = [TDConfig defaultTDConfig];
    config.debugMode = [params[@"debugModel"] intValue];
    [ThinkingAnalyticsSDK startWithAppId:appId withUrl:serverUrl withConfig:config];
}

ThinkingAnalyticsSDK * sharedInstance(NSDictionary *params) {
    ThinkingAnalyticsSDK *instance = nil;
    NSString *appId = nil;
    if (params != nil) {
        appId = params[@"appId"];
    }
    if (stringIsEmpty(appId)) {
        instance = [ThinkingAnalyticsSDK sharedInstance];
    } else {
        instance = [ThinkingAnalyticsSDK sharedInstanceWithAppid:appId];
    }
    return instance;
}

+ (void)identify:(NSDictionary *)params {
    [sharedInstance(params) identify:params[@"distinctId"]];
}

+ (NSDictionary *)getDistinctId:(NSDictionary *)params {
    NSString *distinctId = [sharedInstance(params) getDistinctId];
    return [NSDictionary dictionaryWithObjectsAndKeys:distinctId, @"distinctId", nil];
}

+ (void)login:(NSDictionary *)params {
    [sharedInstance(params) login:params[@"accountId"]];
}

/*
+ (NSDictionary *)getAccountId:(NSDictionary *)params {
    NSString *accountId = [sharedInstance(params) getAccountId];
    return [NSDictionary dictionaryWithObjectsAndKeys:accountId, @"accountId", nil];
}
 */

+ (void)logout:(NSDictionary *)params {
    [sharedInstance(params) logout];
}


+ (void)setLogLevel:(NSDictionary *)params {
    TDLoggingLevel level = TDLoggingLevelNone;
    
    if (params) {
        int l = [params[@"logLevel"] intValue];
        switch (l) {
            case 1:
                level = TDLoggingLevelError;
                break;
            case 2:
                level = TDLoggingLevelInfo;
                break;
            case 3:
                level = TDLoggingLevelDebug;
                break;
            default:
                break;
        }
    }
    [ThinkingAnalyticsSDK setLogLevel:level];
}

+ (void)track:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) track:params[@"eventName"] properties:params[@"properties"]];
}

+ (void)trackFirst:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    TDFirstEventModel *firstModel = nil;
    if (stringIsEmpty(params[@"eventId"])) {
        firstModel = [[TDFirstEventModel alloc] initWithEventName:params[@"eventName"]];
    } else {
        firstModel = [[TDFirstEventModel alloc] initWithEventName:params[@"eventName"] firstCheckID:params[@"eventId"]];
    }
    firstModel.properties = params[@"properties"];
    [sharedInstance(params) trackWithEventModel:firstModel];
}

+ (void)trackUpdate:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    TDUpdateEventModel *updateModel = [[TDUpdateEventModel alloc] initWithEventName:params[@"eventName"] eventID:params[@"eventId"]];
    updateModel.properties = params[@"properties"];
    [sharedInstance(params) trackWithEventModel:updateModel];
}

+ (void)trackOverwrite:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    TDOverwriteEventModel *overwriteModel = [[TDOverwriteEventModel alloc] initWithEventName:params[@"eventName"] eventID:params[@"eventId"]];
    overwriteModel.properties = params[@"properties"];
    [sharedInstance(params) trackWithEventModel:overwriteModel];
}


+ (void)setSuperProperties:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) setSuperProperties:params[@"properties"]];
}

+ (void)unsetSuperProperties:(NSDictionary *)params {
    [sharedInstance(params) unsetSuperProperty:params[@"property"]];
}

+ (void)clearSuperProperties:(NSDictionary *)params {
    [sharedInstance(params) clearSuperProperties];
}

+ (NSDictionary *)currentSuperProperties:(NSDictionary *)params {
    NSDictionary *properties = [sharedInstance(params) currentSuperProperties];
    return [NSDictionary dictionaryWithObjectsAndKeys:properties, @"properties", nil];
}


+ (void)registerDynamicSuperProperties:(NSDictionary *)params {
    [sharedInstance(params) registerDynamicSuperProperties:^NSDictionary<NSString *,id> * _Nonnull{
        NSDictionary *properties = [NSDictionary dictionary];
        
        return properties;
    }];
}

//+ (void)dynamicProperties:(NSDictionary *)params {
//    cocos2d::LuaObjcBridge::pushLuaFunctionById(self.luaHander);
//
//    cocos2d::LuaValueDict item;
//    item["str"] = cocos2d::LuaValue::stringValue("hello");
//    item["int"] = cocos2d::LuaValue::intValue(1000);
//    item["bool"] = cocos2d::LuaValue::booleanValue(TRUE);
//    cocos2d::LuaObjcBridge::getStack()->pushLuaValueDict(item);
//    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
//
//    cocos2d::LuaObjcBridge::releaseLuaFunctionById(self.luaHander);
//}

+ (NSDictionary *)getPresetProperties:(NSDictionary *)params {
    TDPresetProperties *presetProperties = [sharedInstance(params) getPresetProperties];
    return presetProperties.toEventPresetProperties;
}

+ (void)timeEvent:(NSDictionary *)params {
    [sharedInstance(params) timeEvent:params[@"eventName"]];
}

+ (void)userSet:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_set:params[@"properties"]];
}

+ (void)userSetOnce:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_setOnce:params[@"properties"]];
}

+ (void)userAdd:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_add:params[@"properties"]];
}

+ (void)userAppend:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_append:params[@"properties"]];
}

+ (void)userUniqAppend:(NSDictionary *)params {
    // params = calibrateLuaTable(params);
    // [sharedInstance(params) user_uniqAppend:params[@"properties"]];
}

+ (void)userUnset:(NSDictionary *)params {
    [sharedInstance(params) user_unset:params[@"property"]];
}

+ (void)userDelete:(NSDictionary *)params {
    [sharedInstance(params) user_delete];
}

// autoTrack[appInstall,appStart,appEnd,appCrash] autoTrackProperties
+ (void)enableAutoTrack:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    ThinkingAnalyticsAutoTrackEventType eventType = ThinkingAnalyticsEventTypeNone;
    NSDictionary *autoTrack = params[@"autoTrack"];
    if ([[autoTrack objectForKey:@"appStart"] boolValue]) {
        eventType = eventType | ThinkingAnalyticsEventTypeAppStart;
    }
    if ([[autoTrack objectForKey:@"appEnd"] boolValue]) {
        eventType = eventType | ThinkingAnalyticsEventTypeAppEnd;
    }
    if ([[autoTrack objectForKey:@"appCrash"] boolValue]) {
        eventType = eventType | ThinkingAnalyticsEventTypeAppViewCrash;
    }
    if ([[autoTrack objectForKey:@"appInstall"] boolValue]) {
        eventType = eventType | ThinkingAnalyticsEventTypeAppInstall;
    }
    [sharedInstance(params) enableAutoTrack:eventType properties:params[@"autoTrackProperties"]];
}

+ (void)enableTracking:(NSDictionary *)params {
    BOOL enable = [params[@"enable"] boolValue];
    [sharedInstance(params) enableTracking:enable];
}

+ (void)optOutTracking:(NSDictionary *)params {
    [sharedInstance(params) optOutTracking];
}

+ (void)optOutTrackingAndDeleteUser:(NSDictionary *)params {
    [sharedInstance(params) optOutTrackingAndDeleteUser];
}

+ (void)optInTracking:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    if ([params[@"enable"] boolValue]) {
        [sharedInstance(params) optInTracking];
    } else {
        if ([params[@"deleteUser"] boolValue]) {
            [sharedInstance(params) optOutTrackingAndDeleteUser];
        } else {
            [sharedInstance(params) optOutTracking];
        }
    }
}

+ (void)setTrackStatus:(NSDictionary *)params {
    // [sharedInstance(params) setTrackStatus];
}

+ (NSDictionary *)getDeviceId:(NSDictionary *)params {
    NSString *deviceId = [sharedInstance(params) getDeviceId];
    return [NSDictionary dictionaryWithObjectsAndKeys:deviceId, @"deviceId", nil];
}

+ (void)calibrateTime:(NSDictionary *)params {
    NSTimeInterval timestamp = [params[@"timestamp"] floatValue];
    [ThinkingAnalyticsSDK calibrateTime:timestamp];
}

+ (void)calibrateTimeWithNtp:(NSDictionary *)params {
    NSString *ntpServer = params[@"ntpServer"];
    [ThinkingAnalyticsSDK calibrateTimeWithNtp:ntpServer];
}

+ (void)flush:(NSDictionary *)params {
    [sharedInstance(params) flush];
}

BOOL stringIsEmpty(NSString *str) {
    if (str == nil || ![str isKindOfClass:[NSString class]]) {
        return  YES;
    } else if (str.length == 0) {
        return  YES;
    }
    return NO;
}

id objectFormJson(NSString *json) {
    if (stringIsEmpty(json)) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        return nil;
    }
    return  obj;
}

NSDictionary * calibrateLuaTable(NSDictionary *table) {
    NSMutableDictionary *mutTable = [NSMutableDictionary dictionary];
    if ([table isKindOfClass:[NSDictionary class]]) {
        [mutTable addEntriesFromDictionary:table];
        [mutTable enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                id jsonObj = objectFormJson(obj);
                if (jsonObj != nil) {
                    mutTable[key] = jsonObj;
                }
            } else if ([obj isKindOfClass:[NSDictionary class]]) {
                obj = calibrateLuaTable(obj);
                mutTable[key] = obj;
            }
        }];
    }
    return mutTable;
}

@end
