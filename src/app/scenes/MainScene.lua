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

    local bundleId = presetProperties.bundleId -- 包名
    local mOS =  presetProperties.os -- os类型，如Android
    local systemLanguage = presetProperties.systemLanguage -- 手机系统语言类型
    local screenWidth = presetProperties.screenWidth -- 屏幕宽度
    local screenHeight = presetProperties.screenHeight -- 屏幕高度
    local deviceModel = presetProperties.deviceModel -- 设备型号
    local deviceId = presetProperties.deviceId -- 设备唯一标识
    local carrier = presetProperties.carrier -- 手机SIM卡运营商信息，双卡双待时，取主卡的运营商信息
    local manufacturer = presetProperties.manufacturer -- 手机制造商 如HuaWei
    local networkType = presetProperties.networkType -- 网络类型
    local osVersion = presetProperties.osVersion -- 系统版本号
    local appVersion = presetProperties.appVersion -- app版本号
    local zoneOffset = presetProperties.zoneOffset -- 时区偏移值
	print(bundleId, mOS, systemLanguage, screenWidth, screenHeight,
	deviceModel, deviceId, carrier, manufacturer, networkType,
	osVersion, appVersion, zoneOffset)
end

return MainScene
