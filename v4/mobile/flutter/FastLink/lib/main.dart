// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import 'package:flutter/material.dart';
import 'loginView.dart';
import 'fastlinkView.dart';
import 'eventsInfoView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/loginView',
        routes: {
          '/loginView': (context) => LoginView(),
          '/fastlinkView': (context) => FastLinkView(),
          '/eventsInfoView': (context) => EventsInfoView(),
        },
        debugShowCheckedModeBanner: false);
  }
}
