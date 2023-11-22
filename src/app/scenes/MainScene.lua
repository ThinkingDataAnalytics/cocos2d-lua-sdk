local TDAnalytics = require("TDAnalytics")

function initSDK(params)
    if not params then
        params = {
            appId = '22e445595b0f42bd8c5fe35bc44b88d6',
            serverUrl = 'https://receiver-ta-dev.thinkingdata.cn'
        }
    end
    print( 'run -> initSDK: ' .. json.encode(params) )
    local debug = TDAnalytics.debugModel.debugOff
    if params["model"] == 'Debug' then 
        debug = TDAnalytics.debugModel.debugOn
    end
    TDAnalytics.setLogLevel(TDAnalytics.logLevel.logLevelDebug)
    -- TDAnalytics.init(params.appId, params.serverUrl, debug)
    TDAnalytics.init(params.appId, params.serverUrl)

    TDAnalytics.init('debug-appid', params.serverUrl)
    
    TDAnalytics.enableAutoTrack({
        appStart = true,
        appEnd = true,
        appInstall = true
    })
    TDAnalytics.enableAutoTrack({
        appStart = true,
        appEnd = true,
        appInstall = true
    }, 'debug-appid')
end
function track(params) 
    if not params then
        params = {
            event_name = "TA",
            properties = {
                product_name = '商品名称',
            }
        }
    end
    print( 'run -> track' .. json.encode(params) )
    TDAnalytics.track(params.event_name, params.properties);
    TDAnalytics.track(params.event_name, params.properties, 'debug-appid');
end
function trackFirst(params) 
    if not params then
        params = {
            event_name = "TA",
            event_id = "event_id_10001",
            properties = {
                product_name = '商品名称',
            }
        }
    end
    print( 'run -> trackFirst' .. json.encode(params) )
    if not params.event_id then
        TDAnalytics.trackFirst(params.event_name, nil, params.properties)
        TDAnalytics.trackFirst(params.event_name, nil, params.properties, 'debug-appid')
    else
        TDAnalytics.trackFirst(params.event_name, params.event_id, params.properties)
        TDAnalytics.trackFirst(params.event_name, params.event_id, params.properties, 'debug-appid')
    end
end
function trackUpdate(params) 
    if not params then
        params = {
            event_name = "TA",
            event_id = "event_id_10001",
            properties = {
                status = 3,
            }
        }
    end
    print( 'run -> trackUpdate' .. json.encode(params) )
    TDAnalytics.trackUpdate(params.event_name, params.event_id, params.properties)
    TDAnalytics.trackUpdate(params.event_name, params.event_id, params.properties, 'debug-appid')
end
function trackOverwrite(params) 
    if not params then
        params = {
            event_name = "TA",
            event_id = "event_id_10001",
            properties = {
                status = 5,
            }
        }
    end
    print( 'run -> trackOverwrite' .. json.encode(params) )
    TDAnalytics.trackOverwrite(params.event_name, params.event_id, params.properties)
    TDAnalytics.trackOverwrite(params.event_name, params.event_id, params.properties, 'debug-appid')
end
function timeEvent(params) 
    if not params then
        params = {
            event_name = "TA",
        }
    end
    print( 'run -> timeEvent' .. json.encode(params) )
    TDAnalytics.timeEvent(params.event_name)
    TDAnalytics.timeEvent(params.event_name, 'debug-appid')
end
function userSet(params) 
    if not params then
        params = {
            properties = {
                name = "Tiki",
                age = 20
            }
        }
    end
    print( 'run -> userSet' .. json.encode(params) )
    TDAnalytics.userSet(params.properties)
    TDAnalytics.userSet(params.properties, 'debug-appid')
end
function userSetOnce(params) 
    if not params then
        params = {
            properties = {
                name = "Tiki",
                age = 20
            }
        }
    end
    print( 'run -> userSetOnce' .. json.encode(params) )
    TDAnalytics.userSetOnce(params.properties)
    TDAnalytics.userSetOnce(params.properties, 'debug-appid')
end
function userUnset(params) 
    if not params then
        params = {
            property = { "age" }
        }
    end
    print( 'run -> userUnset' .. json.encode(params) )
    for k, v in pairs(params.property) do
        TDAnalytics.userUnset(v)
        TDAnalytics.userUnset(v, 'debug-appid')
    end
end
function userAdd(params) 
    if not params then
        params = {
            properties = {
                age = 20
            }
        }
    end
    print( 'run -> userAdd' .. json.encode(params) )
    TDAnalytics.userAdd(params.properties)
    TDAnalytics.userAdd(params.properties, 'debug-appid')
end
function userAppend(params) 
    if not params then
        params = {
            properties = {
                age = 20
            }
        }
    end
    print( 'run -> userAppend' .. json.encode(params) )
    TDAnalytics.userAppend(params.properties)
    TDAnalytics.userAppend(params.properties, 'debug-appid')
end
function userUniqAppend(params) 
    if not params then
        params = {
            properties = {
                age = 20
            }
        }
    end
    print( 'run -> userUniqAppend' .. json.encode(params) )
    TDAnalytics.userUniqAppend(params.properties)
    TDAnalytics.userUniqAppend(params.properties, 'debug-appid')
end
function userDel(params) 
    if not params then
        params = {}
    end
    print( 'run -> userDel' .. json.encode(params) )
    TDAnalytics.userDelete()
    TDAnalytics.userDelete('debug-appid')
end
function flush(params) 
    if not params then
        params = {}
    end
    print( 'run -> flush' .. json.encode(params) )
    TDAnalytics.flush()
    TDAnalytics.flush('debug-appid')
end
function login(params) 
    if not params then
        params = {
            name = "new-thinker"
        }
    end
    print( 'run -> login' .. json.encode(params) )
    TDAnalytics.login(params.name)
    TDAnalytics.login('debug-account-id', 'debug-appid')
end
function logout(params) 
    if not params then
        params = {}
    end
    print( 'run -> logout' .. json.encode(params) )
    TDAnalytics.logout()
    TDAnalytics.logout('debug-appid')
end
function identify(params) 
    if not params then
        params = {
            name = "nameless-thinker"
        }
    end
    print( 'run -> identify' .. json.encode(params) )
    TDAnalytics.setDistinctId(params.name)
    TDAnalytics.setDistinctId('debug-distinct-id', 'debug-appid')
end
function getDistinctId(params) 
    if not params then
        params = {}
    end
    print( 'run -> getDistinctId' .. json.encode(params) )
    local distinctId = TDAnalytics.getDistinctId();
    print( '[ThinkingAnalytics Log] ' .. distinctId)
    distinctId = TDAnalytics.getDistinctId('debug-appid');
    print( '[ThinkingAnalytics Log] ' .. distinctId)
end
function getDeviceId(params) 
    if not params then
        params = {}
    end
    print( 'run -> getDeviceId' .. json.encode(params) )
    local deviceId = TDAnalytics.getDeviceId();
    print( '[ThinkingAnalytics Log] ' .. deviceId)
end
function getSDKVersion(params)
    if not params then
        params = {}
    end
    print( 'run -> getSDKVersion' .. json.encode(params) )
    local version = TDAnalytics.getSDKVersion();
    print( '[ThinkingAnalytics Log] ' .. version)
end
function setSuperProperties(params) 
    if not params then
        params = {
            properties = {
                channel = "Apple Store",
                vip_level = 100
            }         
        }
    end
    print( 'run -> setSuperProperties' .. json.encode(params) )
    TDAnalytics.setSuperProperties(params.properties)
    TDAnalytics.setSuperProperties(params.properties, 'debug-appid')
end
function unsetSuperProperties(params) 
    if not params then
        params = {
            property = {
                "channel"
            }
        }
    end
    print( 'run -> unsetSuperProperties' .. json.encode(params) )
    for k, v in pairs(params.property) do
        TDAnalytics.unsetSuperProperty(v)
        TDAnalytics.unsetSuperProperty(v, 'debug-appid')
    end
end
function getSuperProperties(params) 
    if not params then
        params = {}
    end
    print( 'run -> getSuperProperties' .. json.encode(params) )
    local superProperties = TDAnalytics.getSuperProperties()
    print( '[ThinkingAnalytics Log] ' .. json.encode(superProperties))
    superProperties = TDAnalytics.getSuperProperties('debug-appid')
    print( '[ThinkingAnalytics Log] ' .. json.encode(superProperties))
end
function clearSuperProperties(params) 
    if not params then
        params = {}
    end
    print( 'run -> clearSuperProperties' .. json.encode(params) )
    TDAnalytics.clearSuperProperties()
    TDAnalytics.clearSuperProperties('debug-appid')
end
function getPresetProperties(params) 
    if not params then
        params = {}
    end
    print( 'run -> getPresetProperties' .. json.encode(params) )
    local presetProperties = TDAnalytics.getPresetProperties()
    print( '[ThinkingAnalytics Log] ' .. json.encode(presetProperties.toEventPresetProperties()))
end
function setDynamicSuperProperties(params)
    if not params then
        params = {}
    end
    print( 'run -> setDynamicSuperProperties' .. json.encode(params) )
    local coin = 0
    local dynamicProperties = function()
        coin = coin +1
        local properties = { coin = coin }
        return properties
    end
    TDAnalytics.setDynamicSuperProperties(dynamicProperties)
    local coin2 = 0
    local dynamicProperties2 = function()
        coin2 = coin2 +2
        local properties = { coin = coin2 }
        return properties
    end
    TDAnalytics.setDynamicSuperProperties(dynamicProperties2, 'debug-appid')
end


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- display.newTTFLabel({text = "Hello, World", size = 64})
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(self)

    display.newRect(cc.rect(0, 0, display.width, display.height), {fillColor = cc.c4f(0.8,0.8,0.8,1), borderColor = cc.c4f(1,1,0,1), borderWidth = 1})
        :addTo(self)

    display.newRect(cc.rect(0, 0, display.width, 200), {fillColor = cc.c4f(0.5,0.5,0.5,1), borderColor = cc.c4f(0,1,1,1), borderWidth = 1})
        :align(display.BOTTOM_CENTER, 0, display.height-200)
        :addTo(self)

    local editbox = ccui.EditBox:create(cc.size(display.width, 200), "", ccui.TextureResType.localType);
    -- self:addChild(editbox);
    editbox:addTo(self)
    editbox:setFontSize(24)
    -- editbox:setFontColor(cc.c3b(1, 0, 0))
    --[[
    editbox:setText("{ \
        \"timeZone\": \"\",\
        \"appId\": \"22e445595b0f42bd8c5fe35bc44b88d6\",\
        \"serverUrl\": \"https://receiver-ta-dev.thinkingdata.cn\",\
        \"autoTrackName\": [\"ta_app_install\", \"ta_app_start\", \"ta_app_end\", \"ta_app_crash\", \"ta_app_view\"],\
        \"model\": \"Debug\"\
    }")
        ]]
    editbox:setPlaceHolder("请输入参数")
    editbox:setPlaceholderFontSize(24)
    editbox:align(display.BOTTOM_CENTER, display.cx, display.height-200)
    editbox:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)  --输入键盘返回类型，done，send，go等KEYBOARD_RETURNTYPE_DONE
    editbox:registerScriptEditBoxHandler(function(eventname,sender) --输入框的事件，主要有光标移进去，光标移出来，以及输入内容改变等
        if eventname == "began" then
            --光标进入，清空内容/选择全部
            -- print( "光标进入，清空内容/选择全部" )
            -- sender:setText("")
        elseif eventname == "ended" then
            --当编辑框失去焦点并且键盘消失的时候被调用
            print( "当编辑框失去焦点并且键盘消失的时候被调用" )
        elseif eventname == "return" then
            --当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用
            print( "当用户点击编辑框的键盘以外的区域，或者键盘的Return按钮被点击时所调用" )
        elseif eventname == "changed" then
            --输入内容改变时调用
            print( "输入内容改变时调用" )
        end        
    end)
    
    local eventList = 
    { 
    	"initSDK",
    	"track", "trackFirst", "trackUpdate", "trackOverwrite", "timeEvent", 
    	"userSet", "userSetOnce", "userUnset", "userAdd", "userAppend", "userUniqAppend", "userDel", 
    	"flush", "login", "logout", "identify", "getDistinctId", "getDeviceId", "getSDKVersion",
    	"setSuperProperties", "unsetSuperProperties", "getSuperProperties", "clearSuperProperties", "getPresetProperties", "setDynamicSuperProperties"
    }

    local funList =     { 
    	initSDK,
    	track, trackFirst, trackUpdate, trackOverwrite, timeEvent, 
    	userSet, userSetOnce, userUnset, userAdd, userAppend, userUniqAppend, userDel, 
    	flush, login, logout, identify, getDistinctId, getDeviceId, getSDKVersion,
    	setSuperProperties, unsetSuperProperties, getSuperProperties, clearSuperProperties, getPresetProperties, setDynamicSuperProperties
    }


    for i = 1,(#eventList) do
        local diff = display.width/6
        local button = ccui.Button:create();
        button:setTitleText(eventList[i]);
        button:setTitleColor(cc.c3b(0.1, 0.1, 0.1));
        button:setTitleFontSize(16);
        -- button:setPosition(200, 200);
        -- button:align(display.CENTER, display.cx, display.cy)
        if i%3==1 then
            button:align(display.CENTER, diff*5, math.floor((i-1)/3)*50 + 20)
        elseif (i%3==2) then
            button:align(display.CENTER, diff*3, math.floor((i-1)/3)*50 + 20)
        else
            button:align(display.CENTER, diff, math.floor((i-1)/3)*50 + 20)
    	end
    
        -- button:addClickEventListener(function ()
        --     print("click button: " .. button:getTitleText())
        -- end)
    
        button:addTouchEventListener(function(sender, evt)
            -- print("touch button (" .. evt ..  "):" .. sender:getTitleText())
            if evt == 2 then
                local funcName = sender:getTitleText()
                local text = editbox:getText()
                local params = json.decode(text)
                -- local fmtFun = loadstring(funcName.."()");
                local fmtFun = loadstring("return function(params) " .. funcName .. " (params) end")();
                print( "type( fmtFun ) is " .. type( fmtFun ) )
                if type( fmtFun ) == "function" then
                    print( "@cocos2dx-lua click on " .. funcName )
                    print( "@cocos2dx-lua 输入参数：\n" .. text )
                    fmtFun(params)
                else
                    print( "@cocos2dx-lua " .. funcName .. " is not function" )
                end
            end
        end)
        button:addTo(self);
    end

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
