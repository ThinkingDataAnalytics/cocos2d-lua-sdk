package org.cocos2dx.lua;

import android.os.Looper;
import android.renderscript.RSIllegalArgumentException;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import cn.thinkingdata.android.TDConfig;
import cn.thinkingdata.android.TDFirstEvent;
import cn.thinkingdata.android.TDOverWritableEvent;
import cn.thinkingdata.android.TDUpdatableEvent;
import cn.thinkingdata.android.ThinkingAnalyticsSDK;

public class ThinkingAnalyticsProxyJava {

	private static ThinkingAnalyticsSDK sInstance = null;

	private static JSONObject jsonObjectFromString(String s) {
		try {
			JSONObject jsonObject = new JSONObject(s);
			return jsonObject;
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return new JSONObject();
	}

	// 设置 SDK 自定义名称/版本号
	public static void setCustomerLibInfo(String name, String version) {
		ThinkingAnalyticsSDK.setCustomerLibInfo(name, version);
	}

	// debugOff = 0, -- 调试关闭
	// debugOnly = 1, -- 调试开启，上报数据，但数据不入库
	// debugOn = 2 -- 调试开启，上报数据，且数据入库
	public static void sharedInstance(String appId, String serverUrl, int debugModel) {
		TDConfig config = TDConfig.getInstance(Cocos2dxActivity.getContext(), appId, serverUrl);
		switch (debugModel) {
			case 1:
				config.setMode(TDConfig.ModeEnum.DEBUG_ONLY);
				break;
			case 2:
				config.setMode(TDConfig.ModeEnum.DEBUG);
				break;
			default:
				config.setMode(TDConfig.ModeEnum.NORMAL);
				break;
		}
		if (null == Looper.myLooper()) {
			Looper.prepare();
		}
		sInstance = ThinkingAnalyticsSDK.sharedInstance(config);
	}

	public static void identify(String distinctId) {
		sInstance.identify(distinctId);
	}

	public static String getDistinctId() {
		return sInstance.getDistinctId();
	}

	public static void login(String accountId) {
		sInstance.login(accountId);
	}

	public static void logout() {
		sInstance.logout();
	}

	//	level==0 不开启，level>0 开启
	public static void setLogLevel(int level) {
		boolean enable = (level>0);
		ThinkingAnalyticsSDK.enableTrackLog(enable);
	}

	public static void track(String eventName, String properties) {
		sInstance.track(eventName, jsonObjectFromString(properties));
	}

	public static void trackFirst(String eventName, String eventId, String properties) {
		TDFirstEvent firstEvent = new TDFirstEvent(eventName, jsonObjectFromString(properties));
		firstEvent.setFirstCheckId(eventId);
		sInstance.track(firstEvent);
	}

	public static void trackUpdate(String eventName, String eventId, String properties) {
		TDUpdatableEvent updatableEvent = new TDUpdatableEvent(eventName, jsonObjectFromString(properties), eventId);
		sInstance.track(updatableEvent);
	}

	public static void trackOverwrite(String eventName, String eventId, String properties) {
		TDOverWritableEvent overWritableEvent = new TDOverWritableEvent(eventName, jsonObjectFromString(properties), eventId);
		sInstance.track(overWritableEvent);
	}

	public static void setSuperProperties(String properties) {
		sInstance.setSuperProperties(jsonObjectFromString(properties));
	}

	public static void unsetSuperProperties(String property) {
		sInstance.unsetSuperProperty(property);
	}

	public static void clearSuperProperties() {
		sInstance.clearSuperProperties();
	}

	public static String currentSuperProperties() {
		return sInstance.getSuperProperties().toString();
	}

	public static String getPresetProperties() {
		return  sInstance.getPresetProperties().toEventPresetProperties().toString();
	}

	public static void timeEvent(String eventName) {
		sInstance.timeEvent(eventName);
	}

	public static void userSet(String properties) {
		sInstance.user_set(jsonObjectFromString(properties));
	}

	public static void userSetOnce(String properties) {
		sInstance.user_setOnce(jsonObjectFromString(properties));
	}

	public static void userAdd(String properties) {
		sInstance.user_add(jsonObjectFromString(properties));
	}

	public static void userAppend(String properties) {
		sInstance.user_append(jsonObjectFromString(properties));
	}

	public static void userUnset(String property) {
		sInstance.user_unset(property);
	}

	public static void userDelete() {
		sInstance.user_delete();
	}

	// 设置自动采集事件类型 autoTrack:{appInstall=true,appStart=true,appEnd=true,appCrash=true} properties
	public static void enableAutoTrack(String autoTrack, String properties) {
		System.out.print("[ThinkingAnalyticsSDK] enableAutoTrack");
		if (sInstance == null) {
			System.out.print("[ThinkingAnalyticsSDK] sInstance is null");
		} else  {
			System.out.print("[ThinkingAnalyticsSDK] sInstance is ok");
		}
		JSONObject jsonObject = jsonObjectFromString(autoTrack);
		List<ThinkingAnalyticsSDK.AutoTrackEventType> eventTypeList = new ArrayList<>();
		if (jsonObject.optBoolean("appInstall")) {
			eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_INSTALL);
		}
		if (jsonObject.optBoolean("appStart")) {
			eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_START);
		}
		if (jsonObject.optBoolean("appEnd")) {
			eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_END);
		}
		if (jsonObject.optBoolean("appCrash")) {
			eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CRASH);
		}
		sInstance.enableAutoTrack(eventTypeList, jsonObjectFromString(properties));
	}

	public static void enableTracking(boolean enable) {
		sInstance.enableTracking(enable);
	}

	public static void optOutTracking() {
		sInstance.optOutTracking();
	}

	public static void optOutTrackingAndDeleteUser() {
		sInstance.optOutTrackingAndDeleteUser();
	}

	public static void optInTracking(boolean enable, boolean deleteUser) {
		if (enable) {
			sInstance.optInTracking();
		} else {
			if (deleteUser) {
				sInstance.optOutTrackingAndDeleteUser();
			} else {
				sInstance.optOutTracking();
			}
		}
	}

	public static String getDeviceId() {
		return sInstance.getDeviceId();
	}
}