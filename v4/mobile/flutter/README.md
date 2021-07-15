# FastLink - Flutter

This Sample App demostrates the steps, you need to follow to Integrate the FastLink Application in the Flutter Project

## Getting Started

FastLink uses the Client Credentials authentication mechanism. You need to pass the valid AccessToken while authenticating the FastLink Application. You can find more information regarding this in <a href="https://developer.yodlee.com/docs/api/1.1/getting-started-with-cc" _blank>Getting started with Client Credentials</a> link.

### How to run the Project
Follow the steps below to run the project in your system:

Step 1: Open the project in editor like `Android Studio`

Step 2: Open the Config.dart file and update the `FASTLINK_URL` constant.

Step 3: Run the application in Emulator/Connected device

Refer the <a href="https://flutter.dev/docs/get-started/editor">Flutter Setup Guide</a> for more details on the setting up Flutter.

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
