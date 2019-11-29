import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'main.dart';

void main() async {
  var config = Config(
      name: '3bot local',
      threeBotApiUrl: 'http://192.168.2.62:5000/api',
      openKycApiUrl: 'http://192.168.2.62:5005',
      threeBotFrontEndUrl: 'http://192.168.2.62:8081/',
      child: new MyApp());

  init();

  apps = [
    {
      "disabled": true
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
      "url": 'http://192.168.2.62:8082',
      "bg": 'nbh.png',
      "disabled": false,
      "initialUrl": 'http://192.168.2.62:8082',
      "visible": false,
      "id": 1,
      "appid": '192.168.8.66:8082',
      "redirecturl": '/login',
      'cookieUrl': '',
      'localStorageKeys': true,
      'color': 0xFF34495e,
      'errorText': false,
      'permissions': ['CAMERA']
    },
    {
      "disabled": true
    },
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
      "id": 3,
      'cookieUrl': 'https://freeflowpages.com/user/auth/external?authclient=3bot',
      'color': 0xFF708fa0,
      'errorText': false,
      'permissions': [],
      'ffpUrls': [
        'https://staging.freeflowpages.com/s/tf-tokens',
        'https://staging.freeflowpages.com/s/tf-grid-users',
        'https://staging.freeflowpages.com/s/tf-grid-farming',
        'https://staging.freeflowpages.com/s/freeflownation',
        'https://staging.freeflowpages.com/s/3bot'
      ]
    },
    {
      "disabled": true
    }
  ];

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(config);
    logger.log("running main_local_mathias.dart");
  });
}
