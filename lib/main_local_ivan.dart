import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'config.dart';
import 'main.dart';

void main() async {
  var config = Config(
      name: '3bot staging',
      threeBotApiUrl: 'http://192.168.43.129:5000/api',
      openKycApiUrl: 'http://192.168.43.129:5005',
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
      "disabled": true,
      "initialUrl": 'https://staging.freeflowpages.com/',
      "visible": false,
      "id": 0,
      'cookieUrl':
          'https://staging.freeflowpages.com/user/auth/external?authclient=3bot',
      'color': 0xFF708fa0,
      'errorText': false,
      'openInBrowser': false,
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
      "url": 'https://192.168.2.80:8080/',
      "appid": '192.168.2.80:8080',
      "redirecturl": '/login',
      "bg": 'nbh.png',
      "disabled": false,
      "initialUrl": 'https://192.168.2.80:8080/',
      "visible": false,
      "id": 1,
      'cookieUrl': '',
      'localStorageKeys': true,
      'color': 0xFF34495e,
      'errorText': false,
      'openInBrowser': true,
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
      'openInBrowser': false,
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
      "url": 'https://janus.conf.meetecho.com/videoroomtest.html',
      "bg": 'om.jpg',
      "disabled": true,
      "initialUrl": 'https://janus.conf.meetecho.com/videoroomtest.html',
      "visible": false,
      "id": 3,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false,
      'openInBrowser': false,
      'permissions': []
    },
    {
      "content": Icon(
        Icons.add_circle,
        size: 75,
        color: Colors.white,
      ),
      "subheading": 'New Application',
      "bg": 'example.jpg',
      "url": 'https://codepen.io/ivancoene/full/YzKjMdP',
      "disabled": true,
      "initialUrl": 'https://codepen.io/ivancoene/full/YzKjMdP',
      "visible": false,
      "id": 4,
      'cookieUrl': '',
      'color': 0xFF0f296a,
      'errorText': false,
      'openInBrowser': false,
      'permissions': []
    }
  ];

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(config);
    logger.log("running main_staging.dart");
  });
}
