import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:threebotlogin/main.dart';
import 'dart:convert';

import 'package:threebotlogin/screens/ErrorScreen.dart';

String threeBotApiUrl = config.threeBotApiUrl;
Map<String, String> requestHeaders = {'Content-type': 'application/json'};

sendScannedFlag(String hash, String deviceId) async {
  print('$threeBotApiUrl/flag');
  print(deviceId);
  http
      .post('$threeBotApiUrl/flag',
          body: json.encode({'hash': hash, 'deviceId': deviceId, 'isSigned': true}),
          headers: requestHeaders,);
}

Future sendData(String hash, String signedHash, data, selectedImageId) {
  print(data);
  return http
      .post('$threeBotApiUrl/sign',
          body: json.encode({'hash': hash, 'signedHash': signedHash, 'data': data, 'selectedImageId': selectedImageId}),
          headers: requestHeaders);
}

Future checkLoginAttempts(String doubleName) {
  return http.get('$threeBotApiUrl/attempts/$doubleName',
      headers: requestHeaders);
}

Future<int> checkVersionNumber(BuildContext context, String version) async {
  var minVersion;
  
  try {
    minVersion =
          (await http.get('$threeBotApiUrl/minversion', headers: requestHeaders)).body;
  } on SocketException catch(error) {
    logger.log("Can't connect to server: " + error.toString());
  }

  if(minVersion == null) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ErrorScreen(errorMessage: "Can't connect to server.")));
    return -1;
  } else {
    try {
      var min = int.parse(minVersion);
      var current = int.parse(version);
      print((min <= current).toString());

      if(min <= current) {
        return 1;
      }
    } on Exception catch (e) {
      print(e);
      return 0;
    }
  }

  return 0;
}
