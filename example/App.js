import React, {Component} from 'react';
import {
  Text,
  View,
  Switch,
  Button,
  StyleSheet,
  NativeModules,
} from 'react-native';

export default class RNApp extends Component {
  state = {
    isEnable: false,
  };

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
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="触发一个埋点事件"
            onPress={event => {
              console.log('xxxx ' + event);
              NativeModules.GrowingIO.track('touch1', {});
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="打开一个页面"
            onPress={event => {
              console.log('xxxx ' + event);
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="注册弹窗监听"
            onPress={event => {
              console.log('xxxx ' + event);
            }}
          />
        </View>
        <View style={styles.button}>
          <Button
            title="注销弹窗监听"
            onPress={event => {
              console.log('xxxx ' + event);
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
