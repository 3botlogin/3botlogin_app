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
      "id": 0,
      'cookieUrl':
          'https://staging.freeflowpages.com/user/auth/external?authclient=3bot',
      'color': 0xFF708fa0,
      'errorText': false,
      'permissions': []
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
      'permissions': ['CAMERA']
    },
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
      "id": 2,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false,
      'permissions': []
    },
    {
      "content": Text(
        'FreeFlowConnect',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      "subheading": '',
      "url": 'https://www.cam-recorder.com/',
      "bg": 'om.jpg',
      "disabled": true,
      "initialUrl": 'https://www.cam-recorder.com/',
      "visible": false,
      "id": 3,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false,
    'permissions': ['CAMERA', 'MICROPHONE']
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
      "id": 4,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false,
      'permissions': []
    }
  ];

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(config);
    logger.log("running main_staging.dart");
  });
}
