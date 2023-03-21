local ThinkingAnalyticsSDK = require("ThinkingAnalyticsSDK")

local MainScene = class("MainScene", function()
	return display.newScene("MainScene")
end)

function MainScene:ctor()
	display.newSprite("HelloWorld.png")
		:addTo(self)
		:center()

	display.newTTFLabel({text = "Hello, World, iMars", size = 64})
		:align(display.CENTER, display.cx, display.cy)
		:addTo(self)

	print("[Lua msg] MainScene:ctor")
end

function MainScene:onEnter()
	print("[Lua msg] MainScene:onEnter")
	ThinkingAnalyticsDemo()
end

function MainScene:onExit()
	print("[Lua msg] MainScene:onExit")
end

function ThinkingAnalyticsDemo()
	
	local APP_ID = "22e445595b0f42bd8c5fe35bc44b88d6"
	local SERVER_URL = "https://receiver-ta-dev.thinkingdata.cn"

    ThinkingAnalyticsSDK.setLogLevel(ThinkingAnalyticsSDK.logLevel.logLevelDebug)
    ThinkingAnalyticsSDK.calibrateTime(1585633785954)
    -- ThinkingAnalyticsSDK.calibrateTimeWithNtp("time.apple.com")
    ThinkingAnalyticsSDK.init(APP_ID, SERVER_URL, ThinkingAnalyticsSDK.debugModel.debugOff)
    local autoTack = {
        appInstall = true, 
        appStart = true, 
        appEnd = true
    }
    ThinkingAnalyticsSDK.enableAutoTrack(autoTack)

    ThinkingAnalyticsSDK.login("LuaAccountId") 
    ThinkingAnalyticsSDK.identify("LuaDistinctId")

    local distinctId = ThinkingAnalyticsSDK.getDistinctId()
    print("distinctId = ", distinctId)

    local deviceId = ThinkingAnalyticsSDK.getDeviceId()
    print("deviceId = ", deviceId)


    ThinkingAnalyticsSDK.clearSuperProperties()

    ThinkingAnalyticsSDK.setSuperProperties({
        channel = "App Storeeeeeeeeeeeee",
        trip = {"Carrrrrrrrrrrr", "Trainnnnnnnnnnnnnn"}
    })

    ThinkingAnalyticsSDK.unsetSuperProperty("trip")

    local currentSuperProperties = ThinkingAnalyticsSDK.currentSuperProperties()
    print("currentSuperProperties = ", json.encode(currentSuperProperties))

    local presetProperties = ThinkingAnalyticsSDK.getPresetProperties()
    local properties = presetProperties.toEventPresetProperties()
    print("presetProperties = ", json.encode(properties))

    print("presetProperties.bundleId = ", presetProperties.bundleId)

    ThinkingAnalyticsSDK.setDynamicSuperProperties(function()
        local properties = {
            today = os.date("%Y-%m-%d")
        }
        return properties
    end)

    local properties = {
        test_string="string",
        test_number=123.456,
        test_bool=true,
        test_date=os.date("%Y-%m-%d %H:%M:%S"),
        test_list={"a","b","c"},
        test_params={test_string__="string__"},
        test_params_list={
            {test_string__="string__"},
            {test_string__="string__"}
        }
    }
    ThinkingAnalyticsSDK.track("Click", properties)

    ThinkingAnalyticsSDK.trackFirst("Click_First", "Click_First_EventId", {
        test_string="first_string"
    })

    ThinkingAnalyticsSDK.trackUpdate("Click_Update", "Click_Update_EventId", {
        test_string="new_string"
    })

    ThinkingAnalyticsSDK.trackOverwrite("Click_Overwrite", "Click_Overwrite_EventId", {
        test_string="new_string"
    })

    ThinkingAnalyticsSDK.timeEvent("TimeEvent")
    ThinkingAnalyticsSDK.track("TimeEvent", {})

    ThinkingAnalyticsSDK.userSet({
        name = "iMars",
        age = 22,
        birthday = os.date("%Y-%m-%d %H:%M:%S"),
        isVip = true
    })

    ThinkingAnalyticsSDK.userSetOnce({
        registTime = os.date("%Y-%m-%d %H:%M:%S")
    })

    ThinkingAnalyticsSDK.userAdd({
        age = 1
    })

    ThinkingAnalyticsSDK.userAppend({
        goods = {"Porsche", "Ferrari"}
    })

    ThinkingAnalyticsSDK.userUnset("age")

    ThinkingAnalyticsSDK.userDelete()

    ThinkingAnalyticsSDK.logout()

    -- ThinkingAnalyticsSDK.enableTracking(false)
    -- ThinkingAnalyticsSDK.track("Event_Test_1", {})
    -- ThinkingAnalyticsSDK.enableTracking(true)
    -- ThinkingAnalyticsSDK.track("Event_Test_2", {})
    -- -- ThinkingAnalyticsSDK.optInTracking(false)
    -- -- ThinkingAnalyticsSDK.track("Event_Test_3", {})
    -- -- ThinkingAnalyticsSDK.optInTracking(true)
    -- -- ThinkingAnalyticsSDK.track("Event_Test_4", {})
    -- ThinkingAnalyticsSDK.optInTracking(false, true)
    -- ThinkingAnalyticsSDK.track("Event_Test_5", {})
    -- ThinkingAnalyticsSDK.optInTracking(true)
    -- ThinkingAnalyticsSDK.track("Event_Test_6", {})

    local presetProperties = ThinkingAnalyticsSDK.getPresetProperties()
    print("presetProperties = ", json.encode(presetProperties.toEventPresetProperties()))

    local bundleId = presetProperties.bundleId 
    local mOS =  presetProperties.os
    local systemLanguage = presetProperties.systemLanguage 
    local screenWidth = presetProperties.screenWidth
    local screenHeight = presetProperties.screenHeight 
    local deviceModel = presetProperties.deviceModel 
    local deviceId = presetProperties.deviceId
    local carrier = presetProperties.carrier 
    local manufacturer = presetProperties.manufacturer 
    local networkType = presetProperties.networkType 
    local osVersion = presetProperties.osVersion 
    local appVersion = presetProperties.appVersion 
    local zoneOffset = presetProperties.zoneOffset
	print(bundleId, mOS, systemLanguage, screenWidth, screenHeight,
	deviceModel, deviceId, carrier, manufacturer, networkType,
	osVersion, appVersion, zoneOffset)
end

return MainScene
