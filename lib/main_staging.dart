import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'config.dart';
import 'main.dart';

void main() async {
  var config = Config(
      name: '3bot staging',
      threeBotApiUrl: 'https://login.staging.jimber.org/api',
      openKycApiUrl: 'https://openkyc.staging.jimber.org',
      threeBotFrontEndUrl: 'https://login.staging.jimber.org/',
      child: new MyApp());

  init();

  apps = [
    {"disabled": true},
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
      "appid": 'wallet.staging.jimber.org',
      "redirecturl": '/login',
      "bg": 'nbh.png',
      "disabled": false,
      "initialUrl": 'https://wallet.staging.jimber.org',
      "visible": false,
      "id": 1,
      'cookieUrl': '',
      'localStorageKeys': true,
      'color': 0xFF34495e,
      'errorText': false,
      'openInBrowser': true,
      'permissions': ['CAMERA']
    },
    {"disabled": true},
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
      "url": 'https://staging.freeflowpages.com/',
      "bg": 'ffp.jpg',
      "disabled": false,
      "initialUrl": 'https://staging.freeflowpages.com/',
      "visible": false,
      "id": 3,
      'cookieUrl':
          'https://staging.freeflowpages.com/user/auth/external?authclient=3bot',
      'color': 0xFF708fa0,
      'errorText': false,
      'openInBrowser': false,
      'permissions': [],
      'ffpUrls': [
        'https://freeflowpages.com/s/tf-tokens',
        'https://freeflowpages.com/s/tf-grid-users',
        'https://freeflowpages.com/s/tf-grid-farming',
        'https://freeflowpages.com/s/freeflownation',
        'https://freeflowpages.com/s/3bot'
      ]
    },
    {
      "disabled": false,
      "content": Text(
        'ChatApp',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      "subheading": 'Chat with your 3Bot',
      "disabled": false,
      "url": 'https://google.com/',
      "initialUrl": 'https://google.com/',
      'cookieUrl': '',
      "visible": false,
      "id": 4,
      'color': 0xFF708fa0,
      'errorText': false,
      'permissions': [],
    }
  ];

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(config);
    logger.log("running main_staging.dart");
  });
}
