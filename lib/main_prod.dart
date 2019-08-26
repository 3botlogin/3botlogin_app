import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'main.dart';

void main() {
  var config = Config(
      name: '3bot',
      threeBotApiUrl: 'https://login.threefold.me/api',
      openKycApiUrl: 'https://openkyc.live/',
      threeBotFrontEndUrl: 'https://login.threefold.me/',
      child: new MyApp()
  );

  init();

  apps = [
    {
      "content": Text(
        'FreeFlowPages',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      "subheading": 'Where privacy and social media co-exist.',
      "bg": 'ffp.jpg',
      "disabled": false,
      "initialUrl": 'https://freeflowpages.com/',
      "visible": false,
      "id": 0,
      'cookieUrl':
          'https://freeflowpages.com/user/auth/external?authclient=3bot',
      'color': 0xFF708fa0,
      'errorText': false
    },/*
    {
      "content": Text(
        'OpenBrowser',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      "subheading": 'By Jimber',
      "url": 'https://broker.jimber.org/',
      "bg": 'jimber.png',
      "disabled": false,
      "initialUrl": 'https://broker.jimber.org/',
      "visible": false,
      "id": 1,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false
    },*/
    {
      "content": Text(
        'FreeflowConnect',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      "subheading": '',
      "url": 'https://cowork-lochristi.threefold.work/',
      "bg": 'om.jpg',
      "disabled": false,
      "initialUrl": 'https://cowork-lochristi.threefold.work/',
      "visible": false,
      "id": 1,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false
    },
    {
      "content": Text(
        'NBH Digital Wallet',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      "subheading": '',
      "url": 'https://wallet.staging.jimber.org',
      "bg": 'nbh.png',
      "disabled": false,
      "initialUrl": 'https://wallet.staging.jimber.org',
      "visible": false,
      "id": 2,
      'cookieUrl': '',
      'color': 0xFF34495e,
      'errorText': false
    },
    {
      "content": Icon(
        Icons.add_circle,
        size: 75,
        color: Colors.white,
      ),
      "subheading": 'New Application',
      "bg": 'example.jpg',
      "url": 'https://jimber.org/app',
      "disabled": true,
      "initialUrl": 'https://cowork-lochristi.threefold.work',
      "visible": false,
      "id": 3,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false
    }
  ];
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(config);
      logger.log("running main_prod.dart");
    });
}