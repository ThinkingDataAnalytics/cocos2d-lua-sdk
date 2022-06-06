## ThinkingAnalytics Cocos2d-Lua SDK

ThinkingAnalytics Cocos2d-Lua SDK 

详细的使用说明，请参考我们的[官方使用手册](https://docs.thinkingdata.cn/ta-manual/latest/installation/installation_menu/client_sdk/cocos2d_lua_sdk_installation/cocos2d_lua_sdk_installation.html)。

### 一、集成方法

#### 2.1 小游戏平台集成（以微信小游戏为例）

```lua
    -- 项目 ID，上报地址
    local APP_ID = "YOUR_APP_ID"
    local SERVER_URL = "YOUR_SERVER_URL"

    -- 设置打印日志
    ThinkingAnalyticsSDK.setLogLevel(ThinkingAnalyticsSDK.logLevel.logLevelDebug)
    
    -- 初始化 Cocos2d-Lua SDK
    ThinkingAnalyticsSDK.init(APP_ID, SERVER_URL, ThinkingAnalyticsSDK.debugModel.debugOff)
```

此后，即可使用我们提供接口追踪用户属性变更和用户行为事件。

```lua
    -- 上报普通事件
    local properties = {
        test_string="string",
        test_number=123.456,
        test_bool=true,
        test_date=os.date("%Y-%m-%d %H:%M:%S"),
        test_list={"a","b","c"}
    }
    ThinkingAnalyticsSDK.track("Click", properties)

    -- 上报用户属性
    ThinkingAnalyticsSDK.userSet({
        name = "Thinker",
        age = 22,
        birthday = os.date("%Y-%m-%d %H:%M:%S"),
        isVip = true
    })
```

### 二、部分功能使用说明
#### 2.1 公共属性

公共属性包含两种，事件公共属性和动态公共属性。公共属性是所有事件都会加上的属性。如果出现相同key值的属性，其优先级为：
`用户自定义事件属性` > `动态公共属性` > `事件公共属性`

事件公共属性相关的接口如下:

```lua
    -- 获取当前公共属性
    ThinkingAnalyticsSDK.currentSuperProperties();

    -- 设置公共属性，调用后，公共属性为 {superKeyString: "super value", superKeyDouble: 134.44}
    ThinkingAnalyticsSDK.setSuperProperties({
        superKeyString = "super value",
        superKeyDouble = 134.44
    })

    -- 再次执行设置公共属性时，如果已经有同名Key，则覆盖；如果没有，则会新增. 调用如下代码后，
    -- 公共属性变为： {superKeyString: "super value new", superKeyDouble: 134.44, superKeyInt: 123}
    ThinkingAnalyticsSDK.setSuperProperties({
        superKeyString = "super value new",
        superKeyInt = 123
    })

    -- 删除某个公共属性，调用后变为：{superKeyDouble: 134.44, superKeyInt: 123}
    ThinkingAnalyticsSDK.unsetSuperProperty("superKeyString");

    -- 清空公共属性
    ThinkingAnalyticsSDK.clearSuperProperties();
```

动态公共属性接口接受一个 function 作为参数，该 funtion 必须返回合法的属性值。

```lua
    -- 通过动态公共属性设置 today 作为事件属性上报
    ThinkingAnalyticsSDK.setDynamicSuperProperties(function()
        local properties = {
            today = os.date("%Y-%m-%d")
        }
        return properties
    end)
```
