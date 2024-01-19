package org.cocos2dx.lua;

import android.os.Looper;
import android.renderscript.RSIllegalArgumentException;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.thinkingdata.analytics.TDConfig;
import cn.thinkingdata.analytics.TDFirstEvent;
import cn.thinkingdata.analytics.TDOverWritableEvent;
import cn.thinkingdata.analytics.TDUpdatableEvent;
import cn.thinkingdata.analytics.ThinkingAnalyticsSDK;

public class TDAnalyticsProxy {

	private static ThinkingAnalyticsSDK sInstance = null;
	private static Map<String, ThinkingAnalyticsSDK> sInstanceMap = new HashMap<String, ThinkingAnalyticsSDK>();

	private static JSONObject jsonObjectFromString(String s) {
		try {
			JSONObject jsonObject = new JSONObject(s);
			return jsonObject;
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return new JSONObject();
	}

	private static ThinkingAnalyticsSDK getInstance(String appId) {
		ThinkingAnalyticsSDK analyticsSDK = sInstanceMap.get(appId);
		if (analyticsSDK == null) {
			analyticsSDK = sInstance;
		}
		return analyticsSDK;
	}

	public static void setCustomerLibInfo(String name, String version) {
		ThinkingAnalyticsSDK.setCustomerLibInfo(name, version);
	}

	// debugOff = 0, 
	// debugOnly = 1, 
	// debugOn = 2 
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
		ThinkingAnalyticsSDK analyticsSDK = ThinkingAnalyticsSDK.sharedInstance(config);
		if (sInstance == null) {
			sInstance = analyticsSDK;
		}
		sInstanceMap.put(appId, analyticsSDK);
	}

	public static void identify(String distinctId, String appId) {
		getInstance(appId).identify(distinctId);
	}

	public static String getDistinctId(String appId) {
		return getInstance(appId).getDistinctId();
	}

	public static void login(String accountId, String appId) {
		getInstance(appId).login(accountId);
	}

	public static void logout(String appId) {
		getInstance(appId).logout();
	}

	public static void setLogLevel(boolean enableLog) {
		ThinkingAnalyticsSDK.enableTrackLog(enableLog);
	}

	public static void track(String eventName, String properties, String appId) {
		getInstance(appId).track(eventName, jsonObjectFromString(properties));
	}

	public static void trackFirst(String eventName, String eventId, String properties, String appId) {
		TDFirstEvent firstEvent = new TDFirstEvent(eventName, jsonObjectFromString(properties));
		firstEvent.setFirstCheckId(eventId);
		getInstance(appId).track(firstEvent);
	}

	public static void trackUpdate(String eventName, String eventId, String properties, String appId) {
		TDUpdatableEvent updatableEvent = new TDUpdatableEvent(eventName, jsonObjectFromString(properties), eventId);
		getInstance(appId).track(updatableEvent);
	}

	public static void trackOverwrite(String eventName, String eventId, String properties, String appId) {
		TDOverWritableEvent overWritableEvent = new TDOverWritableEvent(eventName, jsonObjectFromString(properties), eventId);
		getInstance(appId).track(overWritableEvent);
	}

	public static void setSuperProperties(String properties, String appId) {
		getInstance(appId).setSuperProperties(jsonObjectFromString(properties));
	}

	public static void unsetSuperProperties(String property, String appId) {
		getInstance(appId).unsetSuperProperty(property);
	}

	public static void clearSuperProperties(String appId) {
		getInstance(appId).clearSuperProperties();
	}

	public static String currentSuperProperties(String appId) {
		return getInstance(appId).getSuperProperties().toString();
	}

	public static String getPresetProperties() {
		return  getInstance(null).getPresetProperties().toEventPresetProperties().toString();
	}

	public static void timeEvent(String eventName, String appId) {
		getInstance(appId).timeEvent(eventName);
	}

	public static void userSet(String properties, String appId) {
		getInstance(appId).user_set(jsonObjectFromString(properties));
	}

	public static void userSetOnce(String properties, String appId) {
		getInstance(appId).user_setOnce(jsonObjectFromString(properties));
	}

	public static void userAdd(String properties, String appId) {
		getInstance(appId).user_add(jsonObjectFromString(properties));
	}

	public static void userAppend(String properties, String appId) {
		getInstance(appId).user_append(jsonObjectFromString(properties));
	}

	public static void userUniqAppend(String properties, String appId) {
//		getInstance(appId).user_uniqAppend(jsonObjectFromString(properties));
	}

	public static void userUnset(String property, String appId) {
		getInstance(appId).user_unset(property);
	}

	public static void userDelete(String appId) {
		getInstance(appId).user_delete();
	}

	//  autoTrack:{appInstall=true,appStart=true,appEnd=true,appCrash=true} properties
	public static void enableAutoTrack(String autoTrack, String properties, String appId) {
		System.out.print("[ThinkingAnalyticsSDK] enableAutoTrack");
		if (getInstance(appId) == null) {
			System.out.print("[ThinkingAnalyticsSDK] SDK is null");
		} else  {
			System.out.print("[ThinkingAnalyticsSDK] SDK is ok");
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
		getInstance(appId).enableAutoTrack(eventTypeList, jsonObjectFromString(properties));
	}

	public static void enableTracking(boolean enable, String appId) {
		getInstance(appId).enableTracking(enable);
	}

	public static void optOutTracking(String appId) {
		getInstance(appId).optOutTracking();
	}

	public static void optOutTrackingAndDeleteUser(String appId) {
		getInstance(appId).optOutTrackingAndDeleteUser();
	}

	public static void optInTracking(boolean enable, boolean deleteUser, String appId) {
		if (enable) {
			getInstance(appId).optInTracking();
		} else {
			if (deleteUser) {
				getInstance(appId).optOutTrackingAndDeleteUser();
			} else {
				getInstance(appId).optOutTracking();
			}
		}
	}

	public static void setTrackStatus(int status, String appId) {
		// getInstance(appId).setTrackStatus(status);
	}

	public static String getDeviceId() {
		return getInstance(null).getDeviceId();
	}

	public static void calibrateTime(float timestamp) {
		getInstance(null).calibrateTime((long) timestamp);
	}

	public static void calibrateTimeWithNtp(String ntpServer) {
		getInstance(null).calibrateTimeWithNtp(ntpServer);
	}

	public static void flush(String appId) {
		getInstance(appId).flush();
	}
}