
# react-native-growing-touch

## Getting started

`$ npm install react-native-growing-touch --save`

### Mostly automatic installation

`$ react-native link react-native-growing-touch`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-growing-touch` and add `RNGrowingTouch.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNGrowingTouch.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.growingio.android.sdk.gtouch.rn.RNGrowingTouchPackage;` to the imports at the top of the file
  - Add `new RNGrowingTouchPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-growing-touch'
  	project(':react-native-growing-touch').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-growing-touch/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-growing-touch')
  	```


## Usage
```javascript
import RNGrowingTouch from 'react-native-growing-touch';

// TODO: What to do with the module?
RNGrowingTouch;
```
  