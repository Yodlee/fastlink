# FastLink - React Native

This Sample App demostrates the steps, you need to follow to Integrate the FastLink Application in the React Native Project

## Getting Started

FastLink uses the Client Credentials authentication mechanism. You need to pass the valid AccessToken while authenticating the FastLink Application. You can find more information regarding this in <a href="https://developer.yodlee.com/docs/api/1.1/getting-started-with-cc" _blank>Getting started with Client Credentials</a> link.

### How to run the Project

Follow the following steps to run the project in your system:

Step 1: Navigate to the FastLink folder and run the following command in the Terminal

`npm install`

or if you are using the `yarn` then you can run the following command:

`yarn install`

Step 2: Once the node_modules are installed, if you are running the iOS project then you need to install the pod dependencies. To install pods run the following command:

`pod install`

Note that, you should have configured the cocoapods in your system. If not, then you can install it by referring the <a href="https://cocoapods.org/">Cocoapods</a> installation link.

Step 3: Next, Open the Config.js file and update the `fastLinkURL` constant.

Step 4: Running the project in Android and iOS

To run the Android project, open the emulator and run the following command:

`npx react-native run-android`

To run the iOS project, run the following command:

`npx react-native run-ios`

Refer the <a href="https://reactnative.dev/docs/environment-setup">React Native Environment Setup Guide</a> for more details on the setting up React Native Environment.

### Sample App Details

This app has the three views.

-   LoginView

    Where you can update the FastLink URL, Access Token and modify the extra params which needs to be passed.

-   FastLinkView

    In this view WebView instance is been created and FastLink is loaded in the WebView

-   EventsInfoView

    This view shows the all Native events which are sent from FastLink to native.

> Note:
> We have provided a sample code for integrating FastLink in WebView for testing purpose only. This is not production ready code.
