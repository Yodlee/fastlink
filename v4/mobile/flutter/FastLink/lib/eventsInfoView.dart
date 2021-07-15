// Copyright (c) 2021 Yodlee, Inc. All Rights Reserved.
// Licensed under the MIT License. See `LICENSE` for details.

import 'dart:convert';

import 'package:flutter/material.dart';

class EventsInfoViewArguments {
  final List eventsInfoMap;

  EventsInfoViewArguments(this.eventsInfoMap);
}

class EventsInfoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JsonEncoder encoder = new JsonEncoder.withIndent('\t\t\t\t');

    final EventsInfoViewArguments routeParams =
        ModalRoute.of(context).settings.arguments as EventsInfoViewArguments;

    List eventsInfo = [];

    if (routeParams?.eventsInfoMap != null) {
      eventsInfo = routeParams?.eventsInfoMap;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Events Info'), actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/loginView');
            },
            child: Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ]),
        body: Scrollbar(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(children: <Widget>[
                  Text(
                      'Following are the Events sent from FastLink Application:\n\n'),
                  Text(encoder.convert(eventsInfo))
                ]))));
  }
}
