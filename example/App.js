import React, {Component} from 'react';
import {
  Text,
  View,
  Switch,
  Button,
  StyleSheet,
  NativeModules,
} from 'react-native';

import GrowingTouch from 'react-native-growing-touch'

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
            paddingTop: 10,
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
                onLoadSuccess: (eventId, eventType) => {
                  console.log('RNApp onLoadSuccess: eventId = ' + eventId + ', eventType = ' + eventType);
                },
                onLoadFailed: (eventId, eventType, errorCode, description) => {
                  console.log('RNApp onLoadFailed: eventId = ' + eventId + ', eventType = ' + eventType + ', errorCode = ' + errorCode + ', description = ' + description);
                },
                onClicked: (eventId, eventType, openUrl) => {
                  console.log('RNApp onClicked: eventId = ' + eventId + ', eventType = ' + eventType + ', openUrl = ' + openUrl);
                },
                onCancel: (eventId, eventType) => {
                  console.log('RNApp onCancel: eventId = ' + eventId + ', eventType = ' + eventType);
                },
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
