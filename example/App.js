import React, {Component} from 'react';
import {
  Text,
  View,
  Switch,
  Button,
  StyleSheet,
  NativeModules,
} from 'react-native';


// 开发依赖
import GrowingTouch from './GrowingTouch'

// 线上依赖
// import GrowingTouch from 'react-native-growing-touch'

export default class RNApp extends Component {
  static first = false;

  state = {
    isEnable: true,
  };

  async componentDidMount(): void {
    if (this.first === true) {
      return;
    }
    this.first = true;
    let enable = await GrowingTouch.isEventPopupEnabled();
    console.log('RNApp isEventPopupEnabled = ' + enable);
    if (!enable) {
      console.log('RNApp enableEventPopupAndGenerateAppOpenEvent');
      GrowingTouch.enableEventPopupAndGenerateAppOpenEvent();
      GrowingTouch.setEventPopupListener({
        onLoadSuccess: (eventId, eventType) => {
          console.log('RNApp onLoadSuccess: eventId = ' + eventId + ', eventType = ' + eventType);
        },
        onClicked: (eventId, eventType, openUrl) => {
          console.log('RNApp onClicked: eventId = ' + eventId + ', eventType = ' + eventType + ', openUrl = ' + openUrl);
        },
      });
    }
  }

  render() {
    return (
      <View>
        <View
          style={{
            flexDirection: 'row',
            justifyContent: 'center',
            paddingTop: Platform.OS === 'ios' ? 50 : 10,
          }}>
          <Text style={{fontSize: 25}}>触达开关</Text>
          <Switch
            style={{marginLeft: 30, transform: [{scaleX: 1.3}, {scaleY: 1.3}]}}
            value={this.state.isEnable}
            onValueChange={value => {
              this.setState({
                isEnable: value,
              });
              GrowingTouch.setEventPopupEnable(value);
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="触发一个埋点事件"
            onPress={event => {
              NativeModules.GrowingIO.track('touch1', {});
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="打开一个页面"
            onPress={event => {

            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="注册弹窗监听"
            onPress={event => {
              console.log('注册弹窗监听');
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
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="注销弹窗监听"
            onPress={event => {
              console.log('注销弹窗监听');
              GrowingTouch.setEventPopupListener(null);
            }}
          />
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  button: {
    paddingTop: 20,
    paddingLeft: 50,
    paddingRight: 50,
    transform: [{scaleX: 1.3}, {scaleY: 1.3}],
  },
});
