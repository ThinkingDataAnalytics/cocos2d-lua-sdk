-- ThinkingAnalyticsSDK
local ThinkingAnalyticsSDK = {}

local TE_SDK_NAME = "Cocos2d-Lua"
local TE_SDK_VERSION = "1.0.1"
--[[
    Common Log
]]
ThinkingAnalyticsSDK.TELOG = function(...)
    print("[ThinkingEngine] Info: ", ...)
end

--[[
    Merge tables
]]
ThinkingAnalyticsSDK.mergeTables = function(...)
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

--[[
    Returns true if the current platform is iOS
]]
ThinkingAnalyticsSDK.PlatformIOS = function()
    if device.platform == "ios" then
        return true        
    end
    return false
end

--[[
    Returns true if the current platform is Android
]]
ThinkingAnalyticsSDK.PlatformAndroid = function()
    if device.platform == "android" then
        return true        
    end
    return false
end

--[[
    Thinking Analytics SDK Debug Mode
]]
ThinkingAnalyticsSDK.debugModel = {
    debugOff = 0, -- debug off
    debugOnly = 1, -- debug only, upload event datas, but not stored
    debugOn = 2 -- debug mode, upload event datas, and stored
}

-- ThinkingAnalyticsSDK.autoTrack = {
--     appNone = 0,
--     appStart = 1 << 0,
--     appEnd = 1 << 1,
--     appCrash = 1 << 4,
--     appInstall = 1 << 5
-- }

--[[
    Level of logs printting
]]
ThinkingAnalyticsSDK.logLevel = {
    logLevelNone = 0, -- Log off, will not printting
    logLevelError = 1, -- Log error message
    logLevelInfo = 2, -- Log info message
    logLevelDebug = 3 -- Log debug message
}

local javaProxyClass = "org/cocos2dx/lua/ThinkingAnalyticsProxyJava"
--[[
    Set Log Level
    logLevel see <ThinkingAnalyticsSDK.logLevel>
]]
ThinkingAnalyticsSDK.setLogLevel = function(logLevel)    
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "setLogLevel", {
            logLevel = logLevel
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        local enableLog = false
        if (logLevel ~= ThinkingAnalyticsSDK.logLevel.logLevelNone) then
            enableLog = true
        end
	    luaj.callStaticMethod(javaProxyClass, "setLogLevel", {enableLog}, "(Z)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Thinking Analytics SDK Initialization
    appId: project ID
    serverUrl: server url of data uploading 
    debugModel: sdk debug model, see <ThinkingAnalyticsSDK.debugModel>
]]
ThinkingAnalyticsSDK.init = function(appId, serverUrl, debugModel)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "setCustomerLibInfo", {
            name = TE_SDK_NAME,
            version = TE_SDK_VERSION
        })
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "sharedInstance", {
            appId = appId,
            serverUrl = serverUrl,
            debugModel = debugModel
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setCustomerLibInfo", {TE_SDK_NAME, TE_SDK_VERSION}, "(Ljava/lang/String;Ljava/lang/String;)V")
        luaj.callStaticMethod(javaProxyClass, "sharedInstance", {appId, serverUrl, debugModel}, "(Ljava/lang/String;Ljava/lang/String;I)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Set DistinctId ID
    distinctId: distinct ID
]]
ThinkingAnalyticsSDK.identify = function(distinctId)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "identify", {
            distinctId = distinctId
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "identify", {distinctId}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

end

--[[
    Get DistinctId ID
    return: distinct ID
]]
ThinkingAnalyticsSDK.getDistinctId = function()
    if ThinkingAnalyticsSDK.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "getDistinctId", {})
        if ok then
            return ret.distinctId
        end
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getDistinctId", {}, "()Ljava/lang/String;")
        if ok then
            return ret
        end
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Set AccountId ID
    accountId: account ID
]]
ThinkingAnalyticsSDK.login = function(accountId)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "login", {
            accountId = accountId
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "login", {accountId}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

    
end

--[[
    Get AccountId ID
    return: account ID
]]
-- ThinkingAnalyticsSDK.getAccountId = function()
-- end

--[[
    Clear AccountId ID
]]
ThinkingAnalyticsSDK.logout = function()
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "logout", {})
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "logout", {}, "()V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

    
end

--[[
    Set Super Properties
    properties: super properties, all event will track with super properties
]]
ThinkingAnalyticsSDK.setSuperProperties = function(properties)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "setSuperProperties", {
            properties = properties
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setSuperProperties", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Delete the specified Super Property
    property: property key to delete
]]
ThinkingAnalyticsSDK.unsetSuperProperty = function(property)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "unsetSuperProperties", {
            property = property
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "unsetSuperProperties", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end 
end

--[[
    Delete all Super Properties
]]
ThinkingAnalyticsSDK.clearSuperProperties = function()
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "clearSuperProperties", {})
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "clearSuperProperties", {}, "()V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

    
end

--[[
    Get Current Super Properties
    return: super properties
]]
ThinkingAnalyticsSDK.currentSuperProperties = function()
    if ThinkingAnalyticsSDK.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "currentSuperProperties", {})
        if ok then
            return ret
        end
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "currentSuperProperties", {}, "()Ljava/lang/String;")
        if ok then
            return json.decode(ret)
        end
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
    return {}
end

--[[
    Get Preset Properties
    return: preset properties
]]
ThinkingAnalyticsSDK.getPresetProperties = function()
    local presetProperties = {}
    if ThinkingAnalyticsSDK.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "getPresetProperties", {})
        if ok then
            presetProperties.properties = ret
            -- return ret
        end
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getPresetProperties", {}, "()Ljava/lang/String;")
        if ok then
            presetProperties.properties = json.decode(ret)
            -- return json.decode(ret)
        end
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
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

--[[
    Set Dynamic Properties
    dynamicProperties: dynamic properties callback function
]]
ThinkingAnalyticsSDK.setDynamicSuperProperties = function (dynamicProperties)
    ThinkingAnalyticsSDK.dynamicProperties = dynamicProperties
end

--[[
    Enable Auto Track Events
    autoTrack: auto track event info
    autoTrack.appStart: bool, app start event
    autoTrack.appEnd: bool, app end event
    autoTrack.appInstall: bool, app install event
]]
ThinkingAnalyticsSDK.enableAutoTrack = function(autoTrack)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        local args = {
            autoTrack = autoTrack,
            callback = function (msg)
                ThinkingAnalyticsSDK.TELOG("autoTrack callback: ", msg)
            end
        }
            args = ThinkingAnalyticsSDK.encodeProperties(args)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "enableAutoTrack", args)
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "enableAutoTrack", {json.encode(autoTrack), json.encode({})}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

end

--[[
    Track a Normal Event
    eventName: event name
    properties: event properties
]]
ThinkingAnalyticsSDK.track = function(eventName, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        ThinkingAnalyticsSDK.mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        local arg = {
            eventName = eventName,
            properties = properties
        }
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "track", arg)
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "track", {eventName, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

end

--[[
    Track a First Event
    The first event refers to the ID of a device or other dimension, which will only be recorded once.
    eventName: event name
    eventId: event ID,
    properties: event properties
]]
ThinkingAnalyticsSDK.trackFirst = function(eventName, eventId, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        ThinkingAnalyticsSDK.mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "trackFirst", {
            eventName = eventName,
            eventId = eventId,
            properties = properties
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackFirst", {eventName, eventId, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end

end

--[[
    Track a Updatable Event
	You can implement the requirement to modify event data in a specific scenario through updatable events. 
	Updatable events need to specify an ID that identifies the event and pass it in when the updatable event object is created.
    eventName: event name
    eventId: event ID,
    properties: event properties
]]
ThinkingAnalyticsSDK.trackUpdate = function(eventName, eventId, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        ThinkingAnalyticsSDK.mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "trackUpdate", {
            eventName = eventName,
            eventId = eventId,
            properties = properties
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackUpdate", {eventName, eventId, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Track a Overwritable Event
	Overwritable events will completely cover historical data with the latest data, which is equivalent to deleting the previous data and storing the latest data in effect. 
    eventName: event name
    eventId: event ID,
    properties: event properties
]]
ThinkingAnalyticsSDK.trackOverwrite = function(eventName, eventId, properties)
    if type(ThinkingAnalyticsSDK.dynamicProperties) == 'function' then
        ThinkingAnalyticsSDK.mergeTables(properties, ThinkingAnalyticsSDK.dynamicProperties())
    end
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "trackOverwrite", {
            eventName = eventName,
            eventId = eventId,
            properties = properties
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackOverwrite", {eventName, eventId, json.encode(properties)}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Record the event duration, call this method to start the timing, 
	stop the timing when the target event is uploaded, 
	and add the attribute #duration to the event properties, in seconds.
	eventName: Event name
]]
ThinkingAnalyticsSDK.timeEvent = function(eventName) 
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "timeEvent", {
            eventName = eventName
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "timeEvent", {eventName}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Sets the user property, replacing the original value with the new value if the property already exists.
	properties: User properties
]]
ThinkingAnalyticsSDK.userSet = function(properties)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userSet", {
            properties = properties
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userSet", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Sets a single user attribute, ignoring the new attribute value if the attribute already exists.
	properties: User properties
]]
ThinkingAnalyticsSDK.userSetOnce = function(properties)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userSetOnce", {
            properties = properties
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userSetOnce", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Adds the numeric type user attributes
	properties: User properties
]]
ThinkingAnalyticsSDK.userAdd = function(properties)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userAdd", {
            properties = properties
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userAdd", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Append a user attribute of the List type.
	properties: User properties
]]
ThinkingAnalyticsSDK.userAppend = function(properties)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        properties = ThinkingAnalyticsSDK.encodeProperties(properties)
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userAppend", {
            properties = properties
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userAppend", {json.encode(properties)}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Reset user properties
	property: User property
]]
ThinkingAnalyticsSDK.userUnset = function(property)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userUnset", {
            property = property
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userUnset", {property}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
	Delete the user attributes,This operation is not reversible and should be performed with caution.
]]
ThinkingAnalyticsSDK.userDelete = function()

    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "userDelete", {})
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userDelete", {}, "()V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Enable Event Tracking
    enable: bool
]]
ThinkingAnalyticsSDK.enableTracking = function(enable)

    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "enableTracking", {
            enable = enable
        })    
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "enableTracking", {enable}, "(Z)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Enable Event Tracking
    enable: bool
    deleteUser: whether to delete the user info
]]
ThinkingAnalyticsSDK.optInTracking = function(enable, deleteUser)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "optInTracking", {
            enable = enable,
            deleteUser = deleteUser
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "optInTracking", {enable, deleteUser}, "(ZZ)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

-- ThinkingAnalyticsSDK.optInTracking = function(enable)
--     ThinkingAnalyticsSDK.optInTracking(enable, false)
-- end

--[[
	Get a Device ID
	return: device ID 
]]
ThinkingAnalyticsSDK.getDeviceId = function()
    if ThinkingAnalyticsSDK.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("ThinkingAnalyticsProxy", "getDeviceId", {})
        if ok then
            return ret.deviceId
        end
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getDeviceId", {}, "()Ljava/lang/String;")
        if ok then
            return ret
        end
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Calibrate Time
    Event time will be calibrated
    timestamp: timestamp, ms
]]
ThinkingAnalyticsSDK.calibrateTime = function(timestamp)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "calibrateTime", {
            timestamp = timestamp
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "calibrateTime", {timestamp}, "(F)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Calibrate Time
    Event time will be calibrated
    ntpServer: ntp server
]]
ThinkingAnalyticsSDK.calibrateTimeWithNtp = function(ntpServer)
    if ThinkingAnalyticsSDK.PlatformIOS() then
        luaoc.callStaticMethod("ThinkingAnalyticsProxy", "calibrateTimeWithNtp", {
            ntpServer = ntpServer
        })
    elseif ThinkingAnalyticsSDK.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "calibrateTimeWithNtp", {ntpServer}, "(Ljava/lang/String;)V")
    else
        ThinkingAnalyticsSDK.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    On Calling Objectives-C, table type parameters cannot be nested table, need to be converted to string,
    do not support date type, need to be formatted
]]
ThinkingAnalyticsSDK.encodeProperties = function(properties)
    -- ThinkingAnalyticsSDK.TELOG("ThinkingAnalyticsSDK.encodeProperties ....... : ")
    for key,value in pairs(properties) do
        -- ThinkingAnalyticsSDK.TELOG("key = ", key, "type(value) = ", type(value))
        if (type(value) == "table") then
            local valueStr = json.encode(value)
            -- ThinkingAnalyticsSDK.TELOG("ThinkingAnalyticsSDK.encodeProperties table value Str is: ", valueStr)
            properties[key] = valueStr
        elseif (type(value) == "table") then
        end
    end
    return properties
end


return ThinkingAnalyticsSDK