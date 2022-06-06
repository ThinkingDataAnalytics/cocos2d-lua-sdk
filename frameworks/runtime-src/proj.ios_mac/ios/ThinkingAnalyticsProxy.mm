//
//  ThinkingAnalyticsProxy.m
//  demo iOS
//
//  Created by huangdiao on 2022/3/10.
//

#import "ThinkingAnalyticsProxy.h"
#include "platform/ios/CCLuaObjcBridge.h"
#import <ThinkingSDK/ThinkingAnalyticsSDK.h>

@interface ThinkingAnalyticsProxy ()

@end

@implementation ThinkingAnalyticsProxy

/* ========== begin of singleton ===========  */
__strong static ThinkingAnalyticsProxy *_singleton = nil;

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (ThinkingAnalyticsProxy *)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _singleton = [[super allocWithZone:NULL] init];
    });
    return _singleton;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

/* ========== end of singleton ===========  */

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"ThinkingAnalyticsProxy";
        _luaHander = -1;
    }
    return self;
}

- (void)delay
{
    // 1. lua 函数压栈
    cocos2d::LuaObjcBridge::pushLuaFunctionById(self.luaHander);

    // 2. 构建参数，压栈
    cocos2d::LuaValueDict item;
    item["str"] = cocos2d::LuaValue::stringValue("hello");
    item["int"] = cocos2d::LuaValue::intValue(1000);
    item["bool"] = cocos2d::LuaValue::booleanValue(TRUE);
    cocos2d::LuaObjcBridge::getStack()->pushLuaValueDict(item);
    // 3. 调用函数
    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);

    // 4. 释放 func 引用计数
    cocos2d::LuaObjcBridge::releaseLuaFunctionById(self.luaHander);
}

+ (NSDictionary *)LuaOCTest:(NSDictionary *)dict
{
    if ([dict objectForKey:@"num"]) {
        // 测试 lua 传递过来的 数字
        NSLog(@"== get lua num:%d", [[dict objectForKey:@"num"] intValue]);
    }
    if ([dict objectForKey:@"str"]) {
        // 测试 lua 传递过来的 字符串
        NSLog(@"== get lua num:%@", [dict objectForKey:@"str"]);
    }
    if ([dict objectForKey:@"cb"]) {
        // 保存 handler，handler在传递过来的时候，已经被引用计数+1保护。
        [ThinkingAnalyticsProxy sharedInstance].luaHander = [[dict objectForKey:@"cb"] intValue];
    }

    // 测试延迟调用
    [[ThinkingAnalyticsProxy sharedInstance] performSelector:@selector(delay) withObject:nil afterDelay:2];

    // 反给lua的返回值。
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [ThinkingAnalyticsProxy sharedInstance].name, @"name",
            [NSNumber numberWithInt:[ThinkingAnalyticsProxy sharedInstance].luaHander], @"luaHander",
            nil];
}

static NSString * APP_ID = @"22e445595b0f42bd8c5fe35bc44b88d6";
static NSString * SERVER_URL = @"https://receiver-ta-dev.thinkingdata.cn";

+ (void)startSDK:(NSDictionary *)data {
    
    [ThinkingAnalyticsSDK setLogLevel:TDLoggingLevelDebug];
    // 初始化
    ThinkingAnalyticsSDK *instance = [ThinkingAnalyticsSDK startWithAppId:APP_ID withUrl:SERVER_URL];
    
    [instance track:@"test_event"];
}

+ (void)setCustomerLibInfo:(NSDictionary *)params {
    NSString *name = params[@"name"];
    NSString *version = params[@"version"];
    [ThinkingAnalyticsSDK setCustomerLibInfoWithLibName:name libVersion:version];
}

// 初始化TA
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

// 根据Lua传参params，获取TA实例
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

// 设置访客ID distinctId
+ (void)identify:(NSDictionary *)params {
    [sharedInstance(params) identify:params[@"distinctId"]];
}

// 获取访客ID distinctId
+ (NSDictionary *)getDistinctId:(NSDictionary *)params {
    NSString *distinctId = [sharedInstance(params) getDistinctId];
    return [NSDictionary dictionaryWithObjectsAndKeys:distinctId, @"distinctId", nil];
}

// 设置账号ID accountId
+ (void)login:(NSDictionary *)params {
    [sharedInstance(params) identify:params[@"accountId"]];
}

/*
// 获取账号ID accountId
+ (NSDictionary *)getAccountId:(NSDictionary *)params {
    NSString *accountId = [sharedInstance(params) getAccountId];
    return [NSDictionary dictionaryWithObjectsAndKeys:accountId, @"accountId", nil];
}
 */

// 清除账号ID
+ (void)logout:(NSDictionary *)params {
    [sharedInstance(params) logout];
}


// 设置日志级别 logLevel
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

// track普通事件 eventName properties
+ (void)track:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) track:params[@"eventName"] properties:params[@"properties"]];
}

// track首次事件 eventName eventId properties
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

// track可更新事件 eventName eventId properties
+ (void)trackUpdate:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    TDUpdateEventModel *updateModel = [[TDUpdateEventModel alloc] initWithEventName:params[@"eventName"] eventID:params[@"eventId"]];
    updateModel.properties = params[@"properties"];
    [sharedInstance(params) trackWithEventModel:updateModel];
}

// track可重写事件 eventName eventId properties
+ (void)trackOverwrite:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    TDOverwriteEventModel *overwriteModel = [[TDOverwriteEventModel alloc] initWithEventName:params[@"eventName"] eventID:params[@"eventId"]];
    overwriteModel.properties = params[@"properties"];
    [sharedInstance(params) trackWithEventModel:overwriteModel];
}


// 设置公共事件属性 properties
+ (void)setSuperProperties:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) setSuperProperties:params[@"properties"]];
}

// 清除公共事件指定属性 property
+ (void)unsetSuperProperties:(NSDictionary *)params {
    [sharedInstance(params) unsetSuperProperty:params[@"property"]];
}

// 清除公共事件所有属性
+ (void)clearSuperProperties:(NSDictionary *)params {
    [sharedInstance(params) clearSuperProperties];
}

// 获取公共事件所有属性 properties
+ (NSDictionary *)currentSuperProperties:(NSDictionary *)params {
    NSDictionary *properties = [sharedInstance(params) currentSuperProperties];
    return [NSDictionary dictionaryWithObjectsAndKeys:properties, @"properties", nil];
}


// 设置动态公共属性 dynamicProperties
+ (void)registerDynamicSuperProperties:(NSDictionary *)params {
    [sharedInstance(params) registerDynamicSuperProperties:^NSDictionary<NSString *,id> * _Nonnull{
        NSDictionary *properties = [NSDictionary dictionary];
        
        return properties;
    }];
}

//+ (void)dynamicProperties:(NSDictionary *)params {
//    // 1. lua 函数压栈
//    cocos2d::LuaObjcBridge::pushLuaFunctionById(self.luaHander);
//
//    // 2. 构建参数，压栈
//    cocos2d::LuaValueDict item;
//    item["str"] = cocos2d::LuaValue::stringValue("hello");
//    item["int"] = cocos2d::LuaValue::intValue(1000);
//    item["bool"] = cocos2d::LuaValue::booleanValue(TRUE);
//    cocos2d::LuaObjcBridge::getStack()->pushLuaValueDict(item);
//    // 3. 调用函数
//    cocos2d::LuaObjcBridge::getStack()->executeFunction(1);
//
//    // 4. 释放 func 引用计数
//    cocos2d::LuaObjcBridge::releaseLuaFunctionById(self.luaHander);
//}

+ (NSDictionary *)getPresetProperties:(NSDictionary *)params {
    TDPresetProperties *presetProperties = [sharedInstance(params) getPresetProperties];
    return presetProperties.toEventPresetProperties;
}

// 记录事件时长 eventName
+ (void)timeEvent:(NSDictionary *)params {
    [sharedInstance(params) timeEvent:params[@"eventName"]];
}

// 用户属性
// 设置用户属性 properties
+ (void)userSet:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_set:params[@"properties"]];
}

// 设置用户首次属性 properties
+ (void)userSetOnce:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_setOnce:params[@"properties"]];
}

// 累加数值型用户属性 properties
+ (void)userAdd:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_add:params[@"properties"]];
}

// 追加集合型用户属性 properties
+ (void)userAppend:(NSDictionary *)params {
    params = calibrateLuaTable(params);
    [sharedInstance(params) user_append:params[@"properties"]];
}

// 删除用户属性 property
+ (void)userUnset:(NSDictionary *)params {
    [sharedInstance(params) user_unset:params[@"property"]];
}

// 删除用户
+ (void)userDelete:(NSDictionary *)params {
    [sharedInstance(params) user_delete];
}

// 设置自动采集事件类型 autoTrack[appInstall,appStart,appEnd,appCrash] autoTrackProperties
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

// 暂停/开始 事件上报 enable
+ (void)enableTracking:(NSDictionary *)params {
    BOOL enable = [params[@"enable"] boolValue];
    [sharedInstance(params) enableTracking:enable];
}

// 停止事件上报
+ (void)optOutTracking:(NSDictionary *)params {
    [sharedInstance(params) optOutTracking];
}

// 停止事件上报，并删除用户
+ (void)optOutTrackingAndDeleteUser:(NSDictionary *)params {
    [sharedInstance(params) optOutTrackingAndDeleteUser];
}

// 开启事件上报 enable deleteUser
// 在调用optOutTracking/optOutTrackingAndDeleteUser接口停止事件上报之后，可以调用optInTracking重新开启事件上报
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

// 获取设备ID deviceId
+ (NSDictionary *)getDeviceId:(NSDictionary *)params {
    NSString *deviceId = [sharedInstance(params) getDeviceId];
    return [NSDictionary dictionaryWithObjectsAndKeys:deviceId, @"deviceId", nil];
}


// 字符串为空 ( str==nil || str.length == 0 )
BOOL stringIsEmpty(NSString *str) {
    if (str == nil || ![str isKindOfClass:[NSString class]]) {
        return  YES;
    } else if (str.length == 0) {
        return  YES;
    }
    return NO;
}

// 解析json格式字符串
id objectFormJson(NSString *json) {
    if (stringIsEmpty(json)) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        // NSLog(@"%@", error);
        return nil;
    }
    return  obj;
}

// 校准Lua传过来的table类型参数（Lua传值table类型不可以嵌套）
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
