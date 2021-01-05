
package com.growingio.android.sdk.gtouch.rn;


import android.os.Handler;
import android.os.Looper;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.growingio.android.sdk.common.log.Logger;
import com.growingio.android.sdk.gtouch.GTouchManager;
import com.growingio.android.sdk.gtouch.GrowingTouch;
import com.growingio.android.sdk.gtouch.listener.EventPopupListener;

public class RNGrowingTouchModule extends ReactContextBaseJavaModule {
    private static final String TAG = "RNGrowingTouchModule";

    private final ReactApplicationContext mReactContext;
    private final Handler mUIHandler;

    public RNGrowingTouchModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mReactContext = reactContext;
        mUIHandler = new Handler(Looper.getMainLooper());
    }

    @Override
    public String getName() {
        return "RNGrowingTouch";
    }

    @ReactMethod
    public void setEventPopupEnable(final boolean enable) {
        Logger.d(TAG, "setEventPopupEnable: enable = " + enable);
        mUIHandler.post(new Runnable() {
            @Override
            public void run() {
                GrowingTouch.setEventPopupEnable(enable);
            }
        });
    }

    @ReactMethod
    public void isEventPopupEnabled(Promise promise) {
        Logger.d(TAG, "isEventPopupEnabled");
        WritableMap map = Arguments.createMap();
        map.putBoolean("popupEnabled", GrowingTouch.isEventPopupEnabled());
        promise.resolve(map);
    }

    @ReactMethod
    public void enableEventPopupAndGenerateAppOpenEvent() {
        Logger.d(TAG, "enableEventPopupAndGenerateAppOpenEvent");
        mUIHandler.post(new Runnable() {
            @Override
            public void run() {
                GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
            }
        });
    }

    @ReactMethod
    public void isEventPopupShowing(Promise promise) {
        Logger.d(TAG, "isEventPopupShowing");
        WritableMap map = Arguments.createMap();
        map.putBoolean("popupShowing", GrowingTouch.isEventPopupShowing());
        promise.resolve(map);
    }

    @ReactMethod
    public void setEventPopupListener() {
        Logger.d(TAG, "setEventPopupListener");
        mUIHandler.post(new Runnable() {
            @Override
            public void run() {
                GTouchManager.getInstance().getTouchConfig().setEventPopupListener(new ReactEventPopupListener(mReactContext));
            }
        });
    }

    private static final class ReactEventPopupListener implements EventPopupListener {
        private static final String GTOUCH_EVENT_REMINDER = "GTouchEventReminder";
        private final DeviceEventManagerModule.RCTDeviceEventEmitter mEventEmitter;

        public ReactEventPopupListener(ReactApplicationContext context) {
            mEventEmitter = context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class);
        }

        @Override
        public void onLoadSuccess(String eventId, String eventType) {
            Logger.d(TAG, "onLoadSuccess: eventId = " + eventId + ", eventType = " + eventType);
            WritableMap data = Arguments.createMap();
            data.putString("method", "onLoadSuccess");
            data.putString("eventId", eventId);
            data.putString("eventType", eventType);
            mEventEmitter.emit(GTOUCH_EVENT_REMINDER, data);
        }

        @Override
        public void onLoadFailed(String eventId, String eventType, int errorCode, String description) {
            Logger.d(TAG, "onLoadFailed: eventId = " + eventId + ", eventType = " + eventType);
            WritableMap data = Arguments.createMap();
            data.putString("method", "onLoadFailed");
            data.putString("eventId", eventId);
            data.putString("eventType", eventType);
            data.putInt("errorCode", errorCode);
            data.putString("description", description);
            mEventEmitter.emit(GTOUCH_EVENT_REMINDER, data);

        }

        @Override
        public boolean onClicked(String eventId, String eventType, String openUrl) {
            Logger.d(TAG, "onClicked: eventId = " + eventId + ", eventType = " + eventType + ", openUrl = " + openUrl);
            WritableMap data = Arguments.createMap();
            data.putString("method", "onClicked");
            data.putString("eventId", eventId);
            data.putString("eventType", eventType);
            data.putString("openUrl", openUrl);
            mEventEmitter.emit(GTOUCH_EVENT_REMINDER, data);
            return true;
        }

        @Override
        public void onCancel(String eventId, String eventType) {
            Logger.d(TAG, "onCancel: eventId = " + eventId + ", eventType = " + eventType);
            WritableMap data = Arguments.createMap();
            data.putString("method", "onCancel");
            data.putString("eventId", eventId);
            data.putString("eventType", eventType);
            mEventEmitter.emit(GTOUCH_EVENT_REMINDER, data);
        }

        @Override
        public void onTimeout(String eventId, String eventType) {
            Logger.d(TAG, "onTimeout: eventId = " + eventId + ", eventType = " + eventType);
            WritableMap data = Arguments.createMap();
            data.putString("method", "onTimeout");
            data.putString("eventId", eventId);
            data.putString("eventType", eventType);
            mEventEmitter.emit(GTOUCH_EVENT_REMINDER, data);
        }

        @Override
        public boolean popupEventDecideShow(PopupWindowEvent popupWindowEvent, EventPopupDecisionAction eventPopupDecisionAction) {
            return false;
        }
    }

}