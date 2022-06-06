-- ThinkingAnalyticsSDK
local ThinkingAnalyticsSDK = {}

local SDK_NAME = "Cocos2d-Lua"
local SDK_VERSION = "1.0.0"

TALOG = function(...)
    print("[ThinkingAnalytics Log] ", ...)
end

mergeTables = function(...)
    local tabs = { ... }
    if not tabs then
        return {}
    end
    local origin = tabs[1]
    for i = 2, #tabs do
        if origin then
            if tabs[i] then
                for k, v in pairs(tabs[i]) do
                    if (v ~= nil) then
                        origin[k] = v
                    end
                end
            end
        else
            origin = tabs[i]
        end
    end
    return origin
end

PlatformIOS = function()
    if device.platform == "ios" then
        return true        
    end
    return false
end

PlatformAndroid = function()
    if device.platform == "android" then
        return true        
    end
    return false
end

-- 调试模式
ThinkingAnalyticsSDK.debugModel = {
    debugOff = 0, -- 调试关闭
    debugOnly = 1, -- 调试开启，上报数据，但数据不入库
    debugOn = 2 -- 调试开启，上报数据，且数据入库
}

-- ThinkingAnalyticsSDK.autoTrack = {
--     appNone = 0,
--     appStart = 1 << 0,
--     appEnd = 1 << 1,
--     appCrash = 1 << 4,
--     appInstall = 1 << 5
-- }

-- 打印日志级别
ThinkingAnalyticsSDK.logLevel = {
    logLevelNone = 0, -- 打印日志关闭
    logLevelError = 1, -- 打印错误日志
    logLevelInfo = 2, -- 打印详细日志
    logLevelDebug = 3 -- 打印调试日志
}

local javaProxyClass = "org/cocos2dx/lua/ThinkingAnalyticsProxyJava"
-- 设置打印日志级别
-- logLevel 打印日志级别 详细参考: ThinkingAnalyticsSDK.logLevel
ThinkingAnalyticsSDK.setLogLevel = function(logLevel)    
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "setLogLevel", {
            logLevel = logLevel
        })
    elseif PlatformAndroid() then
	    luaj.callStaticMethod(javaProxyClass, "setLogLevel", logLevel, "(I)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 初始化
-- appId 项目ID
-- serverUrl 项目上报地址
-- debugModel 调试模式 详细参考: ThinkingAnalyticsSDK.debugModel
ThinkingAnalyticsSDK.init = function(appId, serverUrl, debugModel)
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "setCustomerLibInfo", {
            name = SDK_NAME,
            version = SDK_VERSION
        })
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "sharedInstance", {
            appId = appId,
            serverUrl = serverUrl,
            debugModel = debugModel
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setCustomerLibInfo", {SDK_NAME, SDK_VERSION}, "(Ljava/lang/String;Ljava/lang/String;)V")
        luaj.callStaticMethod(javaProxyClass, "sharedInstance", {appId, serverUrl, debugModel}, "(Ljava/lang/String;Ljava/lang/String;I)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 设置访客ID
-- distinctId 访客ID
ThinkingAnalyticsSDK.identify = function(distinctId)
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "identify", {
            distinctId = distinctId
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "identify", {distinctId}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

end

-- 获取访客ID
-- return 访客ID
ThinkingAnalyticsSDK.getDistinctId = function()
    if PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "getDistinctId", {})
        if ok then
            return ret.distinctId
        end
    elseif PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getDistinctId", {}, "()Ljava/lang/String;")
        if ok then
            return ret
        end
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 设置账号ID
-- accountId 账号ID
ThinkingAnalyticsSDK.login = function(accountId)
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "login", {
            accountId = accountId
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "login", {accountId}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

    
end

-- 获取账号ID
-- ThinkingAnalyticsSDK.getAccountId = function()
-- end

-- 清除账号ID
ThinkingAnalyticsSDK.logout = function()
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "logout", {})
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "logout", {}, "()V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

    
end

-- 设置事件公共属性
-- properties 事件属性
ThinkingAnalyticsSDK.setSuperProperties = function(properties)
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "setSuperProperties", {
            properties = properties
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setSuperProperties", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 删除事件公共属性 
-- property 属性key
ThinkingAnalyticsSDK.unsetSuperProperty = function(property)
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "unsetSuperProperties", {
            property = property
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "unsetSuperProperties", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end 
end

-- 清除事件公共属性
ThinkingAnalyticsSDK.clearSuperProperties = function()
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "clearSuperProperties", {})
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "clearSuperProperties", {}, "()V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

    
end

-- 获取事件公共属性
-- return 事件公共属性
ThinkingAnalyticsSDK.currentSuperProperties = function()
    if PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "currentSuperProperties", {})
        if ok then
            return ret
        end
    elseif PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "currentSuperProperties", {}, "()Ljava/lang/String;")
        if ok then
            return json.decode(ret)
        end
    else
        TALOG("current platform is not support, ", device.platform)
    end
    return {}
end

-- 获取预置公共属性 
-- return 预置公共属性 
ThinkingAnalyticsSDK.getPresetProperties = function()
    local presetProperties = {}
    if PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "getPresetProperties", {})
        if ok then
            presetProperties.properties = ret
            -- return ret
        end
    elseif PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getPresetProperties", {}, "()Ljava/lang/String;")
        if ok then
            presetProperties.properties = json.decode(ret)
            -- return json.decode(ret)
        end
    else
        TALOG("current platform is not support, ", device.platform)
    end
    presetProperties.toEventPresetProperties = function()
        return presetProperties.properties
    end
    presetProperties.bundleId = presetProperties.properties["#bundle_id"]
    presetProperties.os = presetProperties.properties["#os"]
    presetProperties.systemLanguage = presetProperties.properties["#system_language"]
    presetProperties.screenWidth = presetProperties.properties["#screen_width"]
    presetProperties.screenHeight = presetProperties.properties["#screen_height"]
    presetProperties.deviceModel = presetProperties.properties["#device_model"]
    presetProperties.deviceId = presetProperties.properties["#device_id"]
    presetProperties.carrier = presetProperties.properties["#carrier"]
    presetProperties.manufacturer = presetProperties.properties["#manufacturer"]
    presetProperties.networkType = presetProperties.properties["#network_type"]
    presetProperties.osVersion = presetProperties.properties["#os_version"]
    presetProperties.appVersion = presetProperties.properties["#app_version"]
    presetProperties.zoneOffset = presetProperties.properties["#zone_offset"]
    return presetProperties
end

-- 设置动态公共属性
-- dynamicProperties 动态公共属性，function
ThinkingAnalyticsSDK.setDynamicSuperProperties = function (dynamicProperties)
    ThinkingAnalyticsSDK.dynamicProperties = dynamicProperties
end

-- 开启自动采集事件上报
-- autoTrack 自动采集事件类型集合 appStart=启动事件, appEnd=关闭事件, appInstall=安装事件
ThinkingAnalyticsSDK.enableAutoTrack = function(autoTrack)
    if PlatformIOS() then
        local args = {
            autoTrack = autoTrack,
            callback = function (msg)
                TALOG("autoTrack callback: ", msg)
            end
        }
            args = encodeProperties(args)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "enableAutoTrack", args)
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "enableAutoTrack", {json.encode(autoTrack), json.encode({})}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

end

-- 上报普通事件
-- eventName 事件名称
-- properties 事件属性
ThinkingAnalyticsSDK.track = function(eventName, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if PlatformIOS() then
        properties = encodeProperties(properties)
        local arg = {
            eventName = eventName,
            properties = properties
        }
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "track", arg)
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "track", {eventName, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

end

-- 上报首次事件
-- eventName 事件名称
-- eventId 事件ID
-- properties 事件属性
ThinkingAnalyticsSDK.trackFirst = function(eventName, eventId, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "trackFirst", {
            eventName = eventName,
            eventId = eventId,
            properties = properties
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackFirst", {eventName, eventId, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end

end

-- 上报可更新事件
-- eventName 事件名称
-- eventId 事件ID
-- properties 事件属性
ThinkingAnalyticsSDK.trackUpdate = function(eventName, eventId, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "trackUpdate", {
            eventName = eventName,
            eventId = eventId,
            properties = properties
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackUpdate", {eventName, eventId, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 上报可重写事件
-- eventName 事件名称
-- eventId 事件ID
-- properties 事件属性
ThinkingAnalyticsSDK.trackOverwrite = function(eventName, eventId, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "trackOverwrite", {
            eventName = eventName,
            eventId = eventId,
            properties = properties
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackOverwrite", {eventName, eventId, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

ThinkingAnalyticsSDK.timeEvent = function(eventName) 
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "timeEvent", {
            eventName = eventName
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "timeEvent", {eventName}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 设置用户属性 
-- properties 用户属性
ThinkingAnalyticsSDK.userSet = function(properties)
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userSet", {
            properties = properties
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userSet", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 设置用户首次属性 
-- properties 用户属性
ThinkingAnalyticsSDK.userSetOnce = function(properties)
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userSetOnce", {
            properties = properties
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userSetOnce", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 累加数值型用户属性
-- properties 数值型用户属性
ThinkingAnalyticsSDK.userAdd = function(properties)
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userAdd", {
            properties = properties
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userAdd", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 追加集合型用户属性
-- properties 集合型用户属性
ThinkingAnalyticsSDK.userAppend = function(properties)
    if PlatformIOS() then
        properties = encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userAppend", {
            properties = properties
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userAppend", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 删除用户属性
-- property 用户属性Key
ThinkingAnalyticsSDK.userUnset = function(property)
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userUnset", {
            property = property
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userUnset", {property}, "(Ljava/lang/String;)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 删除用户
ThinkingAnalyticsSDK.userDelete = function()

    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userDelete", {})
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userDelete", {}, "()V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 开始/暂停 事件上报
-- enable true=开始, false=暂停
ThinkingAnalyticsSDK.enableTracking = function(enable)

    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "enableTracking", {
            enable = enable
        })    
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "enableTracking", {enable}, "(Z)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- 开启/停止 事件上报
-- enable true=开启, false=停止
-- deleteUser true=删除用户信息, false=不删除用户信息
ThinkingAnalyticsSDK.optInTracking = function(enable, deleteUser)
    if PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "optInTracking", {
            enable = enable,
            deleteUser = deleteUser
        })
    elseif PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "optInTracking", {enable, deleteUser}, "(ZZ)V")
    else
        TALOG("current platform is not support, ", device.platform)
    end
end

-- ThinkingAnalyticsSDK.optInTracking = function(enable)
--     ThinkingAnalyticsSDK.optInTracking(enable, false)
-- end

ThinkingAnalyticsSDK.getDeviceId = function()

    if PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "getDeviceId", {})
        if ok then
            return ret.deviceId
        end
    elseif PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getDeviceId", {}, "()Ljava/lang/String;")
        if ok then
            return ret
        end
    else
        TALOG("current platform is not support, ", device.platform)
    end
end


-- 调用Objective-C传值table类型，不可以嵌套table，需要格式化成string传递，不支持date类型，需要格式化
encodeProperties = function(properties)
    -- TALOG("encodeProperties ....... : ")
    for key,value in pairs(properties) do
        -- TALOG("key = ", key, "type(value) = ", type(value))
        if (type(value) == "table") then
            local valueStr = json.encode(value)
            -- TALOG("encodeProperties table value Str is: ", valueStr)
            properties[key] = valueStr
        elseif (type(value) == "table") then
        end
    end
    return properties
end


return ThinkingAnalyticsSDK