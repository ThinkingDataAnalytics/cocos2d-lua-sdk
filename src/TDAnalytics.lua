---------------
-- ThinkingData Analytics Cocos2d-Lua SDK.
-- @script TDAnalytics
---------------

local TDAnalytics = {}

local TE_SDK_NAME = "Cocos2d-Lua"
local TE_SDK_VERSION = "2.0.0"
--[[
    Common Log
]]
TDAnalytics.TELOG = function(...)
    print("[ThinkingEngine] Info: ", ...)
end

--[[
    Merge tables
]]
TDAnalytics.mergeTables = function(...)
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
TDAnalytics.PlatformIOS = function()
    if device.platform == "ios" then
        return true        
    end
    return false
end

--[[
    Returns true if the current platform is Android
]]
TDAnalytics.PlatformAndroid = function()
    if device.platform == "android" then
        return true        
    end
    return false
end

--- SDK Debug Mode
TDAnalytics.debugModel = {
    debugOff = 0, -- debug off
    debugOnly = 1, -- debug only, upload event datas, but not stored
    debugOn = 2 -- debug mode, upload event datas, and stored
}

-- TDAnalytics.autoTrack = {
--     appNone = 0,
--     appStart = 1 << 0,
--     appEnd = 1 << 1,
--     appCrash = 1 << 4,
--     appInstall = 1 << 5
-- }

--- Level of logs printting
TDAnalytics.logLevel = {
    logLevelNone = 0, -- Log off, will not printting
    logLevelError = 1, -- Log error message
    logLevelInfo = 2, -- Log info message
    logLevelDebug = 3 -- Log debug message
}

--- SDK Track Status
TDAnalytics.trackStatus = {
    Normal = 0, -- normal status
    Pause = 1, -- pause status, events will not be sended
    Stop = 2, -- stop status, events will not be sended, local storage will be cleared
    SaveOnly = 3 -- save only, events will be saved, but not be posted
}

local javaProxyClass = "org/cocos2dx/lua/TDAnalyticsProxy"
local dynamicPropertiesTable = {}

--- ThinkingData Analytics SDK Initialization.
-- @string appId Project ID
-- @string serverUrl Server url of data uploading 
-- @string debugModel SDK debug model, see TDAnalytics.debugModel
-- @usage
-- TDAnalytics.init("YOUR-APP-ID", "YOUR-SERVER-URL")
TDAnalytics.init = function(appId, serverUrl, debugModel)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "setCustomerLibInfo", {
            name = TE_SDK_NAME,
            version = TE_SDK_VERSION
        })
        luaoc.callStaticMethod("TDAnalyticsProxy", "sharedInstance", {
            appId = appId,
            serverUrl = serverUrl,
            debugModel = debugModel
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setCustomerLibInfo", {TE_SDK_NAME, TE_SDK_VERSION}, "(Ljava/lang/String;Ljava/lang/String;)V")
        luaj.callStaticMethod(javaProxyClass, "sharedInstance", {appId, serverUrl, debugModel}, "(Ljava/lang/String;Ljava/lang/String;I)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Set Log Level
-- @number logLevel see TDAnalytics.logLevel
-- @usage
-- TDAnalytics.setLogLevel(TDAnalytics.logLevel.logLevelInfo)
TDAnalytics.setLogLevel = function(logLevel)    
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "setLogLevel", {
            logLevel = logLevel
        })
    elseif TDAnalytics.PlatformAndroid() then
        local enableLog = false
        if (logLevel ~= TDAnalytics.logLevel.logLevelNone) then
            enableLog = true
        end
        luaj.callStaticMethod(javaProxyClass, "setLogLevel", {enableLog}, "(Z)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Set the distinct ID to replace the default UUID distinct ID
-- @string 	distinctId Distinct ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.setDistinctId( "thinkers" )
TDAnalytics.setDistinctId = function(distinctId, appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "identify", {
            distinctId = distinctId,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "identify", {distinctId, appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end

end

--- Get a Distinct ID: The #distinct_id value in the reported data.
-- @string 	appId Project ID
-- @treturn string Distinct ID
-- @usage
-- TDAnalytics.getDistinctId()
TDAnalytics.getDistinctId = function(appId)
    if TDAnalytics.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("TDAnalyticsProxy", "getDistinctId", { 
            appId = appId 
        })
        if ok then
            return ret.distinctId
        end
    elseif TDAnalytics.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getDistinctId", {appId or ''}, "(Ljava/lang/String;)Ljava/lang/String;")
        if ok then
            return ret
        end
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Set the account ID. Each setting overrides the previous value. Login events will not be uploaded.
-- @string 	accountId Account ID
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.login( "136xxx" )
TDAnalytics.login = function(accountId, appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "login", {
            accountId = accountId,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "login", {accountId, appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Get AccountId ID
    return: account ID
]]
-- TDAnalytics.getAccountId = function()
-- end

--- Clearing the account ID will not upload user logout events.
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.logout()
TDAnalytics.logout = function(appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "logout", {
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "logout", {appId or ''}, "(Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

---Set the public event attribute, which will be included in every event uploaded after that. The public event properties are saved without setting them each time.
-- @tab 	properties Super Properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.setSuperProperties( {
-- 	channel = "Apple Store ",
-- 	vip_level = 100
-- } )
TDAnalytics.setSuperProperties = function(properties, appId)
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "setSuperProperties", {
            properties = properties,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setSuperProperties", {json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Clears a public event attribute
-- @tab 	property Public event attribute key to clear
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.unsetSuperProperty( "vip_level" )
TDAnalytics.unsetSuperProperty = function(property, appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "unsetSuperProperties", {
            property = property,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "unsetSuperProperties", {property, appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end 
end

--- Clear all public event attributes.
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.clearSuperProperties()
TDAnalytics.clearSuperProperties = function(appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "clearSuperProperties", {
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "clearSuperProperties", {appId or ''}, "(Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end

    
end

--- Gets the public event properties that have been set.
-- @string 	appId Project ID
-- @treturn param Super Properties
-- @usage
-- TDAnalytics.getSuperProperties()
TDAnalytics.getSuperProperties = function(appId)
    if TDAnalytics.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("TDAnalyticsProxy", "currentSuperProperties", {
            appId = appId
        })
        if ok then
            return ret.properties
        end
    elseif TDAnalytics.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "currentSuperProperties", {appId or ''}, "(Ljava/lang/String;)Ljava/lang/String;")
        if ok then
            return json.decode(ret)
        end
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
    return {}
end

--- Gets preset properties for all events.
-- @string 	appId Project ID
-- @treturn param Preset Properties
-- @usage
-- TDAnalytics.getPresetProperties()
TDAnalytics.getPresetProperties = function()
    local presetProperties = {}
    if TDAnalytics.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("TDAnalyticsProxy", "getPresetProperties", {})
        if ok then
            presetProperties.properties = ret
            -- return ret
        end
    elseif TDAnalytics.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getPresetProperties", {}, "()Ljava/lang/String;")
        if ok then
            presetProperties.properties = json.decode(ret)
            -- return json.decode(ret)
        end
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
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

--- Set Dynamic Properties
-- @func    dynamicProperties dynamic properties callback function
-- @string 	appId Project ID
-- @usage
-- local coin = 0
-- local dynamicProperties = function()
--     coin = coin +1
--     local properties = { coin = coin }
--     return properties
-- end
-- TDAnalytics.setDynamicSuperProperties(dynamicProperties)
TDAnalytics.setDynamicSuperProperties = function (dynamicProperties, appId)
    if (type(appId) == 'string') then
        dynamicPropertiesTable[appId] = dynamicProperties
    else
        dynamicPropertiesTable['default'] = dynamicProperties
    end
end

--- Enable Auto Track Events
-- @tab     autoTrack auto track event info
-- @bool    autoTrack.appStart bool, app start event
-- @bool    autoTrack.appEnd bool, app end event
-- @bool    autoTrack.appInstall bool, app install event
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.enableAutoTrack({
--     appStart = true,
--     appEnd = true,
--     appInstall = true
-- })
TDAnalytics.enableAutoTrack = function(autoTrack, appId)
    if TDAnalytics.PlatformIOS() then
        local args = {
            autoTrack = autoTrack,
            callback = function (msg)
                TDAnalytics.TELOG("autoTrack callback: ", msg)
            end,
            appId = appId
        }
            args = TDAnalytics.encodeProperties(args)
        luaoc.callStaticMethod("TDAnalyticsProxy", "enableAutoTrack", args)
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "enableAutoTrack", {json.encode(autoTrack), json.encode({}), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end

end

--- Track a Normal Event.
-- @string 	eventName Event name
-- @tab 	properties Event properties
-- @string 	appId Project ID
-- @usage 
-- TDAnalytics.track( "TA", { 
-- 	key_1 = "value_1"
-- } )
TDAnalytics.track = function(eventName, properties, appId)
    local dynamicProperties
    if (type(appId) == 'string') then
        dynamicProperties = dynamicPropertiesTable[appId]
    else
        dynamicProperties = dynamicPropertiesTable['default']
    end
    if type(dynamicProperties) == 'function' then
        TDAnalytics.mergeTables(properties, dynamicProperties())
    end
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        local arg = {
            eventName = eventName,
            properties = properties,
            appId = appId
        }
        luaoc.callStaticMethod("TDAnalyticsProxy", "track", arg)
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "track", {eventName, json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end

end

--- Track a First Event.
-- The first event refers to the ID of a device or other dimension, which will only be recorded once.
-- @string 	eventName Event name
-- @string 	eventId Event ID
-- @tab 	properties Event properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.trackFirst( "FirstEvent", "event_id_00001", { 
-- 	key_1 = "value_1" 
-- })
TDAnalytics.trackFirst = function(eventName, eventId, properties, appId)
    local dynamicProperties
    if (type(appId) == 'string') then
        dynamicProperties = dynamicPropertiesTable[appId]
    else
        dynamicProperties = dynamicPropertiesTable['default']
    end
    if type(dynamicProperties) == 'function' then
        TDAnalytics.mergeTables(properties, dynamicProperties())
    end
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "trackFirst", {
            eventName = eventName,
            eventId = eventId,
            properties = properties,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackFirst", {eventName, eventId, json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end

end

--- Track a Updatable Event.
-- You can implement the requirement to modify event data in a specific scenario through updatable events. 
-- Updatable events need to specify an ID that identifies the event and pass it in when the updatable event object is created.
-- @string 	eventName Event name
-- @string 	eventId Event ID
-- @tab 	properties Event properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.trackUpdate( "UpdateEvent", "UpdateEventId", { 
-- 	key_1 = "value_1" 
-- } )
TDAnalytics.trackUpdate = function(eventName, eventId, properties, appId)
    local dynamicProperties
    if (type(appId) == 'string') then
        dynamicProperties = dynamicPropertiesTable[appId]
    else
        dynamicProperties = dynamicPropertiesTable['default']
    end
    if type(dynamicProperties) == 'function' then
        TDAnalytics.mergeTables(properties, dynamicProperties())
    end
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "trackUpdate", {
            eventName = eventName,
            eventId = eventId,
            properties = properties,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackUpdate", {eventName, eventId, json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Track a Overwritable Event.
-- Overwritable events will completely cover historical data with the latest data, which is equivalent to deleting the previous data and storing the latest data in effect. 
-- @string 	eventName Event name
-- @string 	eventId Event ID
-- @tab 	properties Event properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.trackOverwrite( "OverwriteEvent", "OverwriteEventId", { 
-- 	key_1 = "value_1" 
-- } )
TDAnalytics.trackOverwrite = function(eventName, eventId, properties, appId)
    local dynamicProperties
    if (type(appId) == 'string') then
        dynamicProperties = dynamicPropertiesTable[appId]
    else
        dynamicProperties = dynamicPropertiesTable['default']
    end
    if type(dynamicProperties) == 'function' then
        TDAnalytics.mergeTables(properties, dynamicProperties())
    end
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "trackOverwrite", {
            eventName = eventName,
            eventId = eventId,
            properties = properties,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "trackOverwrite", {eventName, eventId, json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Record the event duration, call this method to start the timing, 
-- stop the timing when the target event is uploaded, 
-- and add the attribute #duration to the event properties, in seconds.
-- @string 	eventName Event name
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.timeEvent( "TA" )
-- -- do something...
-- TDAnalytics.track("TA")
TDAnalytics.timeEvent = function(eventName, appId) 
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "timeEvent", {
            eventName = eventName,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "timeEvent", {eventName, appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Sets the user property, replacing the original value with the new value if the property already exists.
-- @tab 	properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userSet( { 
-- 	name = "Tiki",
-- 	age = 20
-- } )
TDAnalytics.userSet = function(properties, appId)
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "userSet", {
            properties = properties,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userSet", {json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Sets a single user attribute, ignoring the new attribute value if the attribute already exists.
-- @string 	properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userSetOnce( { 
-- 	gender = "male"
-- } )
TDAnalytics.userSetOnce = function(properties, appId)
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "userSetOnce", {
            properties = properties,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userSetOnce", {json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Adds the numeric type user attributes
-- @tab properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userAdd( { 
-- 	age = 1
-- } )
TDAnalytics.userAdd = function(properties, appId)
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "userAdd", {
            properties = properties,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userAdd", {json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Append a user attribute of the List type.
-- @tab properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userAppend( { 
-- 	toys = { "ball" }
-- } )
TDAnalytics.userAppend = function(properties, appId)
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "userAppend", {
            properties = properties,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userAppend", {json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- The element appended to the library needs to be done to remove the processing,and then import.
-- @tab properties User properties
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userUniqAppend( { 
-- 	toys = { "ball", "apple" }
-- } )
TDAnalytics.userUniqAppend = function(properties, appId)
    if TDAnalytics.PlatformIOS() then
        properties = TDAnalytics.encodeProperties(properties)
        luaoc.callStaticMethod("TDAnalyticsProxy", "userUniqAppend", {
            properties = properties,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userUniqAppend", {json.encode(properties), appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Reset user properties
-- @string 	property User property
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.userUnset( "name_1" )
TDAnalytics.userUnset = function(property, appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "userUnset", {
            property = property,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userUnset", {property, appId or ''}, "(Ljava/lang/String;Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Delete the user attributes,This operation is not reversible and should be performed with caution.
-- @string appId Project ID
-- @usage
-- TDAnalytics.userDelete()
TDAnalytics.userDelete = function(appId)

    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "userDelete", {
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "userDelete", {appId or ''}, "(Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Enable Event Tracking
    enable: bool
]]
TDAnalytics.enableTracking = function(enable)

    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "enableTracking", {
            enable = enable,
            appId = appId
        })    
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "enableTracking", {enable, appId or ''}, "(ZLjava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    Enable Event Tracking
    enable: bool
    deleteUser: whether to delete the user info
]]
TDAnalytics.optInTracking = function(enable, deleteUser, appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "optInTracking", {
            enable = enable,
            deleteUser = deleteUser,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "optInTracking", {enable, deleteUser, appId or ''}, "(ZZLjava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

-- TDAnalytics.optInTracking = function(enable)
--     TDAnalytics.optInTracking(enable, false)
-- end

--- Set SDK Track Status
-- @number  status SDK track status, see TDAnalytics.trackStatus
-- @string 	appId Project ID
-- @usage
-- TDAnalytics.setTrackStatus(TDAnalytics.trackStatus.Pause)
TDAnalytics.setTrackStatus = function(status, appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "setTrackStatus", {
            status = status,
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "setTrackStatus", {status, appId or ''}, "(ILjava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Get a Device ID
-- @treturn string Device ID
-- @usage
-- TDAnalytics.getDeviceId()
TDAnalytics.getDeviceId = function()
    if TDAnalytics.PlatformIOS() then
        local ok, ret = luaoc.callStaticMethod("TDAnalyticsProxy", "getDeviceId", {})
        if ok then
            return ret.deviceId
        end
    elseif TDAnalytics.PlatformAndroid() then
        local ok, ret = luaj.callStaticMethod(javaProxyClass, "getDeviceId", {}, "()Ljava/lang/String;")
        if ok then
            return ret
        end
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Calibrate Event Time with Timestamp
-- @number 	timestamp unix timestamp
-- @usage
-- TDAnalytics.calibrateTime(1672502400000)
TDAnalytics.calibrateTime = function(timestamp)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "calibrateTime", {
            timestamp = timestamp
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "calibrateTime", {timestamp}, "(F)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Calibrate Event Time with NTP Server
-- @string 	ntpServer ntp server url
-- @usage
-- TDAnalytics.calibrateTimeWithNtp("time.apple.com")
TDAnalytics.calibrateTimeWithNtp = function(ntpServer)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "calibrateTimeWithNtp", {
            ntpServer = ntpServer
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "calibrateTimeWithNtp", {}, "(Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--- Get SDK Version
-- @treturn	string sdk version
-- @usage
-- TDAnalytics.getSDKVersion()
TDAnalytics.getSDKVersion = function()
    return TE_SDK_VERSION;
end

--- Empty the cache queue. When this api is called, the data in the current cache queue will attempt to be reported.
-- If the report succeeds, local cache data will be deleted.
-- @string 	appId Project ID
-- @usage 
-- TDAnalytics.flush()
TDAnalytics.flush = function(appId)
    if TDAnalytics.PlatformIOS() then
        luaoc.callStaticMethod("TDAnalyticsProxy", "flush", {
            appId = appId
        })
    elseif TDAnalytics.PlatformAndroid() then
        luaj.callStaticMethod(javaProxyClass, "flush", {appId or ''}, "(Ljava/lang/String;)V")
    else
        TDAnalytics.TELOG("current platform is not support, ", device.platform)
    end
end

--[[
    On Calling Objectives-C, table type parameters cannot be nested table, need to be converted to string,
    do not support date type, need to be formatted
]]
TDAnalytics.encodeProperties = function(properties)
    -- TDAnalytics.TELOG("TDAnalytics.encodeProperties ....... : ")
    for key,value in pairs(properties) do
        -- TDAnalytics.TELOG("key = ", key, "type(value) = ", type(value))
        if (type(value) == "table") then
            local valueStr = json.encode(value)
            -- TDAnalytics.TELOG("TDAnalytics.encodeProperties table value Str is: ", valueStr)
            properties[key] = valueStr
        elseif (type(value) == "table") then
        end
    end
    return properties
end


return TDAnalytics