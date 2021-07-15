// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import 'package:flutter/material.dart';
import 'config.dart' as Config;
import 'fastlinkView.dart';

class LoginView extends StatelessWidget {
  String fastLinkURL = Config.FASTLINK_URL;
  String accessToken = "";
  String extraParams = "configName=Aggregation&intentUrl=yodlee://backtofastlink";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ...[
                    new Container(
                      width: 200,
                      height: 150,
                      color: Colors.white,
                      child: new Image.asset('assets/images/yodlee.png'),
                      alignment: Alignment.center,
                    ),
                    TextFormField(
                      initialValue: fastLinkURL,
                      decoration: InputDecoration(
                        labelText: 'FastLink URL',
                      ),
                      onChanged: (value) {
                        fastLinkURL = value;
                      },
                    ),
                    TextFormField(
                      initialValue: accessToken,
                      decoration: InputDecoration(
                        labelText: 'Access Token',
                      ),
                      onChanged: (value) {
                        accessToken = value;
                      },
                    ),
                    TextFormField(
                      initialValue: extraParams,
                      decoration: InputDecoration(
                        labelText: 'Extra Params',
                      ),
                      onChanged: (value) {
                        extraParams = value;
                      },
                    ),
                    RaisedButton(
                      child: Text('Sign in'),
                      onPressed: () async {
                        // Use a JSON encoded string to send
                        Navigator.pushNamed(context, '/fastlinkView',
                            arguments: FastLinkViewArguments(
                                fastLinkURL, accessToken, extraParams));
                      },
                    ),
                  ].expand(
                    (widget) => [
                      widget,
                      SizedBox(
                        height: 24,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
