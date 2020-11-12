import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'eventsInfoView.dart';

class FastLinkViewArguments {
  final String fastLinkURL;
  final String accessToken;
  final String extraParams;

  FastLinkViewArguments(this.fastLinkURL, this.accessToken, this.extraParams);
}

class FastLinkView extends StatelessWidget {
  WebViewController _controller;
  BuildContext fastlinkViewContext;

  String fastLinkURL = "";
  String accessToken = "";
  String extraParams = "";

  var EventsInfoMap = [];

  @override
  Widget build(BuildContext context) {
    fastlinkViewContext = context;
    final FastLinkViewArguments routeParams =
        ModalRoute.of(context).settings.arguments as FastLinkViewArguments;

    fastLinkURL = routeParams.fastLinkURL;
    accessToken = routeParams.accessToken;
    extraParams = routeParams.extraParams;

    return Scaffold(
      appBar: AppBar(
        title: Text('FastLink'),
      ),
      body: WebView(
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'YWebViewHandler',
              onMessageReceived: (JavascriptMessage eventData) {
                _handleEventsFromJS(eventData.message);
              })
        ]),
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadFastLink();
        },
      ),
    );
  }

  _loadFastLink() async {
    String _htmlString = '''<html>
		<body>
			<form name="fastlink-form" action="$fastLinkURL" method="POST">
				<input name="login" value="ashwin2" hidden="true" />
				<input name="password" value="Test@123" hidden="true" />
				<input name="app" value="10003600" hidden="true" />
				<input name="extraParams" value="$extraParams" hidden="true" />
			</form>
			<script type="text/javascript">
				window.onload = function () {
					document.forms["fastlink-form"].submit();
				}
			</script>
		</body>
		</html>''';
    _controller.loadUrl(Uri.dataFromString(_htmlString,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _handleEventsFromJS(message) {
    Map<String, dynamic> eventData = jsonDecode(message);

    print(eventData);
    EventsInfoMap.add(eventData);
    if (eventData["type"] == "OPEN_EXTERNAL_URL") {
      String url = eventData["data"]["url"];
      _launchURL(url);
    }

    if (eventData["type"] == "POST_MESSAGE") {
      String action = eventData["data"]["action"];

      if (action == "exit") {
        Navigator.pushNamed(fastlinkViewContext, '/eventsInfoView',
            arguments: EventsInfoViewArguments(EventsInfoMap));
      }
    }
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      print('Could not launch $url');
    }
  }
}
