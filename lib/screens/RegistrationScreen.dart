import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:threebotlogin/widgets/PinField.dart';
import 'package:threebotlogin/services/userService.dart';
import 'package:threebotlogin/services/3botService.dart';
import 'package:threebotlogin/services/cryptoService.dart';
import 'package:threebotlogin/main.dart';
import 'package:threebotlogin/widgets/Scanner.dart';

class RegistrationScreen extends StatefulWidget {
  final Widget registrationScreen;
  RegistrationScreen({Key key, this.registrationScreen}) : super(key: key);
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  String helperText = "In order to finish registration, scan QR code";
  AnimationController sliderAnimationController;
  Animation<double> offset;
  String qrData = '';
  String pin;

  @override
  void initState() {
    super.initState();
    sliderAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1));
    sliderAnimationController.addListener(() {
      this.setState(() {});
    });

    offset = Tween<double>(begin: 0.0, end:  500.0).animate(CurvedAnimation(
        parent: sliderAnimationController, curve: Curves.bounceOut));
  }

  Widget content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
              width: double.infinity,
              child: Text(
                'REGISTRATION',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21.0),
              ),
            )),
        Container(
            color: Theme.of(context).primaryColor,
            child: Container(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 24.0, bottom: 24.0),
                          child: Center(child: Text(helperText, style: TextStyle(fontSize: 16.0),))),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        padding: EdgeInsets.only(bottom: 24.0),
                        curve: Curves.bounceInOut,
                        width: double.infinity,
                        child: qrData != '' ? PinField(callback: (p) => pinFilledIn(p)) : null,
                      ),
                    ],
                  ),
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Scanner(
        callback: (qr) => gotQrData(qr),
        context: context,
      ),
      Align(alignment: Alignment.bottomCenter, child: content())
    ]));
  }

  void gotQrData(value) {
    setState(() {
      qrData = value;
      helperText = "Choose new pin";
    });
    sliderAnimationController.forward();
    sendScannedFlag(jsonDecode(qrData)['hash'], deviceId);
  }

  Future pinFilledIn(String value) async {
    if (pin == null) {
      setState(() {
        pin = value;
        helperText = 'Confirm pin';
      });
    } else if (pin != value) {

      setState(() {
        pin = null;
        helperText = 'Pins do not match, choose pin';
      });
    } else if (pin == value) {
      var hash = jsonDecode(qrData)['hash'];
      var privateKey = jsonDecode(qrData)['privateKey'];
      var doubleName = jsonDecode(qrData)['doubleName'];
      var email = jsonDecode(qrData)['email'];

      savePin(value);
      savePrivateKey(privateKey);
      saveEmail(email, false);
      saveDoubleName(doubleName);
      
      var signedHash = signHash(hash, privateKey);
      sendSignedHash(hash, await signedHash);
      Navigator.pushReplacementNamed(context, '/success');
    }
  }
}
