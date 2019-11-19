
# react-native-growing-touch
## 环境配置
请确保已经添加埋点SDK、触达原生端SDK，如果没有，请移步至原生端SDK集成文档

## 添加依赖

`$ npm install react-native-growing-touch --save`

### 自动安装 (React Native 0.6.0版本及其以上可以跳过该步骤)

`$ react-native link react-native-growing-touch`

### 手动安装


#### iOS

1. 打开Xcode，在您的工程目录中点击 `Libraries` ➜ `Add Files to [your project's name]`
2. 选择添加 `node_modules` ➜ `react-native-growing-touch` ➜ `RNGrowingTouch.xcodeproj`
3. 选择您的目标项目， `Build Phases` ➜ `Link Binary With Libraries`添加 `libRNGrowingTouch.a` 
4. 运行项目 (`Cmd+R`)<

#### Android

1. 打开您的首页Activity `android/app/src/main/java/[...]/MainActivity.java`
  - 导入包文件 `import com.growingio.android.sdk.gtouch.rn.RNGrowingTouchPackage;`
  - 在`getPackages()` 方法中添加 `new RNGrowingTouchPackage()` 
2. 引入Android Native工程 `android/settings.gradle`:
  	```
  	include ':react-native-growing-touch'
  	project(':react-native-growing-touch').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-growing-touch/android')
  	```
3. 在app中添加Android Native依赖 `android/app/build.gradle`:
  	```
      compile project(':react-native-growing-touch')
  	```
## 引入到文件
```javascript
import GrowingTouch from 'react-native-growing-touch';

// TODO: What to do with the module?
GrowingTouch;
```

## API说明

### 1 设置弹窗开关
#### 1.1 `GrowingTouch.setEventPopupEnable(enable)`
设置弹窗的开关，可以在初始化的时候选择关闭弹窗功能，这样弹窗SDK就不会在APP的logo页和闪屏页显示弹窗，然后在APP的内容页打开时再打开弹窗开关。
#### 1.2 参数说明
参数名|类型|必填|默认值|说明
:---:|:---:|:---:|:---:|:---:
enable|boolean|是|true|开关触达弹窗功能，true开启，false关闭
#### 1.3 代码示例
```javascript
GrowingTouch.setEventPopupEnable(true);
```

### 2 获取弹窗开关状态
#### 2.1 `GrowingTouch.isEventPopupEnabled()`
获取弹窗开关状态。
#### 2.2 代码示例
```javascript
let enable = await GrowingTouch.isEventPopupEnabled();
```

### 3 打开弹窗并触发"打开APP"事件
#### 3.1 `GrowingTouch.enableEventPopupAndGenerateAppOpenEvent()`
打开弹窗并触发"打开APP"事件。

应用场景时：担心弹窗SDK在APP启动的Logo页或者闪屏页显示弹窗，这时可以选择在初始化时关闭弹窗开关，然后在APP的内容页打开时再打开弹窗开关。

如果只是单纯调用`GrowingTouch.setEventPopupEnable(true)`只会打开弹窗开关，并不会触发"打开APP"的弹窗事件。调用该API则会打开弹窗的同时触发一个"打开APP"的弹窗事件。（"打开APP" 对应的是触发时机选择“打开App时”）。
#### 3.2 代码示例
```javascript
let enable = await GrowingTouch.isEventPopupEnabled();
if (!enable) {
  GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
}
```

### 4 弹窗是否正在显示
#### 4.1 `GrowingTouch.isEventPopupShowing()`
弹窗是否正在显示
#### 4.2 代码示例
```javascript
let showing = await GrowingTouch.isEventPopupShowing();
```

### 5 弹窗的事件监听
#### 5.1 `GrowingTouch.setEventPopupListener(listener)`
通过监听获取事件和参数，您可以根据事件和参数以及您的业务场景执行相关的交互。
#### 5.2 代码示例
```javascript
GrowingTouch.setEventPopupListener({
    /**
     * 弹窗显示成功
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     */
    onLoadSuccess: (eventId, eventType) => {
      console.log('RNApp onLoadSuccess: eventId = ' + eventId + ', eventType = ' + eventType);
    },

    /**
     * 弹窗加载失败
     *
     * @param eventId     埋点事件名称
     * @param eventType   事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     * @param errorCode   错误码
     * @param description 错误描述
     */
    onLoadFailed: (eventId, eventType, errorCode, description) => {
      console.log('RNApp onLoadFailed: eventId = ' + eventId + ', eventType = ' + eventType + ', errorCode = ' + errorCode + ', description = ' + description);
    },

    /**
     * 用户点击了弹窗的有效内容。弹窗SDK现在只提供跳转APP内部界面和H5界面两种处理方式。
     * 您可以在这里接管跳转事件，处理需要跳转的url。您也可以自定义Url协议，实现更多业务和交互功能。
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     * @param openUrl   跳转的url
     */
    onClicked: (eventId, eventType, openUrl) => {
      console.log('RNApp onClicked: eventId = ' + eventId + ', eventType = ' + eventType + ', openUrl = ' + openUrl);
    },

    /**
     * 用户关闭了弹窗
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     */
    onCancel: (eventId, eventType) => {
      console.log('RNApp onCancel: eventId = ' + eventId + ', eventType = ' + eventType);
    },

    /**
     * 弹窗显示超时
     *
     * @param eventId   埋点事件名称
     * @param eventType 事件类型，system(弹窗SDK内置的事件)或custom(用户自定义的埋点事件)
     */
    onTimeout: (eventId, eventType) => {
      console.log('RNApp onTimeout: eventId = ' + eventId + ', eventType = ' + eventType);
    },
  });
```


