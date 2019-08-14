import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:threebotlogin/main.dart';
import 'package:threebotlogin/services/openKYCService.dart';
import 'package:threebotlogin/services/userService.dart';
import 'package:threebotlogin/widgets/CustomDialog.dart';
import 'package:threebotlogin/widgets/PinField.dart';

import 'package:threebotlogin/services/FingerprintService.dart';

class PreferenceScreen extends StatefulWidget {
  PreferenceScreen({Key key}) : super(key: key);
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  Map email;
  String doubleName = '';
  String phrase = '';
  bool finger;
  bool emailVerified = false;
  bool showAdvancedOptions = false;
  Icon showAdvancedOptionsIcon = Icon(Icons.keyboard_arrow_down);
  String emailAdress = '';
  final _prefScaffold = GlobalKey<ScaffoldState>();

  var thiscolor = Colors.green;

  @override
  void initState() {
    super.initState();
    getUserValues();
  }

  Future<bool> _onWillPop() {
    var index = 0;
    for (var flutterWebViewPlugin in flutterWebViewPlugins) {
      if (flutterWebViewPlugin != null) {
        if (index == lastAppUsed) {
          flutterWebViewPlugin.show();
          showButton = true;
        }
        index++;
      }
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
          appBar: new AppBar(
            title: Text('Preferences'),
            elevation: 0.0,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Container(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top: 24.0, bottom: 38.0),
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                title: Text("Profile"),
                              ),
                              Material(
                                child: ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text(doubleName),
                                ),
                              ),
                              Material(
                                child: ListTile(
                                  trailing: !emailVerified
                                      ? Icon(Icons.refresh)
                                      : null,
                                  leading: Icon(Icons.mail),
                                  title: Text(emailAdress.toLowerCase()),
                                  subtitle: !emailVerified
                                      ? Text(
                                          "Unverified",
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      : null,
                                  onTap: !emailVerified
                                      ? sendVerificationEmail
                                      : null,
                                ),
                              ),
                              FutureBuilder(
                                future: getPhrase(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Material(
                                      child: ListTile(
                                        trailing: Icon(Icons.visibility),
                                        leading: Icon(Icons.vpn_key),
                                        title: Text("Show Phrase"),
                                        onTap: () async {
                                          if (!finger) {
                                            _showPinDialog('phrase');
                                          } else {
                                            var isValue = await authenticate();
                                            isValue ? _showPhrase() : null;
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              Material(
                                child: ListTile(
                                  leading: Icon(Icons.lock),
                                  title: Text("Change pincode"),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/changepin');
                                  },
                                ),
                              ),
                              Material(
                                child: SwitchListTile(
                                  secondary: Icon(Icons.fingerprint),
                                  value: finger,
                                  title: Text("Fingerprint"),
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    _chooseDialogFingerprint(newValue);
                                    finger = newValue;
                                  },
                                ),
                              ),
                              ExpansionTile(
                                title: Text("Advanced settings"),
                                children: <Widget>[
                                  Material(
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(
                                        "Remove Account From Device",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      trailing: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onTap: _showDialog,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _chooseDialogFingerprint(isValue) async {
    if (isValue) {
      _showEnabledFingerprint();
    } else {
      _showPinDialog('fingerprint');
    }

    setState(() {});
  }

  void _showEnabledFingerprint() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
            image: Icons.error,
            title: "Enable Fingerprint",
            description: new Text(
                "If you enable fingerprint, anyone who has a registered fingerprint on this device will have access to your account."),
            actions: <Widget>[
              FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: new Text("Yes"),
                onPressed: () async {
                  Navigator.pop(context);
                  saveFingerprint(true);
                },
              ),
            ],
          ),
    );
  }

  void _showDisableFingerprint() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
            image: Icons.error,
            title: "Disable Fingerprint",
            description: new Text(
                "Are you sure you want to deactivate fingerprint as authentication method?"),
            actions: <Widget>[
              FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: new Text("Yes"),
                onPressed: () async {
                  Navigator.pop(context);
                  saveFingerprint(false);
                },
              ),
            ],
          ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
            image: Icons.error,
            title: "Are you sure?",
            description: new Text(
                "If you confirm, your account will be removed from this device. You can always recover your account with your doublename, email and phrase."),
            actions: <Widget>[
              FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: new Text("Yes"),
                onPressed: () async {
                  for (var flutterWebViewPlugin in flutterWebViewPlugins) {
                    if (flutterWebViewPlugin != null) {
                      flutterWebViewPlugin.cleanCookies();
                      flutterWebViewPlugin.close();
                      // flutterWebViewPlugin.resetWebviews();
                    }
                  }
                  await clearData();
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                },
              ),
            ],
          ),
    );
  }

  void sendVerificationEmail() async {
    final snackBar = SnackBar(content: Text('Resending verification email...'));
    _prefScaffold.currentState.showSnackBar(snackBar);
    await resendVerificationEmail();
    _showResendEmailDialog();
  }

  void _showResendEmailDialog() {
    logger.log('Dialogging');
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
            image: Icons.check,
            title: "Email has been resend.",
            description: new Text("A new verification email has been send."),
            actions: <Widget>[
              FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void _showPinDialog(callbackParam) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
            image: Icons.dialpad,
            title: "Please enter your pincode",
            description: Container(
              padding: EdgeInsets.only(bottom: 32.0),
              child: PinField(
                callback: checkPin,
                callbackParam: callbackParam,
              ),
            ),
          ),
    );
  }

  Future copySeedPhrase() async {
    Clipboard.setData(new ClipboardData(text: await getPhrase()));
    _prefScaffold.currentState.showSnackBar(SnackBar(
      content: Text('Seedphrase copied to clipboard'),
    ));
  }

  Future checkPin(pin, callbackParam) async {
    if (pin == await getPin()) {
      Navigator.pop(context);
      switch (callbackParam) {
        case 'phrase':
          _showPhrase();
          break;
        case 'fingerprint':
          _showDisableFingerprint();
          break;
      }
    } else {
      Navigator.pop(context);
      _prefScaffold.currentState.showSnackBar(SnackBar(
        content: Text('Pin invalid'),
      ));
    }
  }

  void _showPhrase() async {
    final phrase = await getPhrase();

    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
            hiddenaction: copySeedPhrase,
            image: Icons.create,
            title: "Please write this down on a piece of paper",
            description: new Text(
              phrase.toString(),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  void getUserValues() {
    getDoubleName().then((dn) {
      setState(() {
        doubleName = dn;
      });
    });
    getEmail().then((emailMap) {
      setState(() {
        email = emailMap;
        if (email['email'] != null || email['verified']) {
          emailAdress = email['email'];
          emailVerified = email['verified'];
        }
      });
    });
    getPhrase().then((seedPhrase) {
      setState(() {
        phrase = seedPhrase;
      });
    });
    getFingerprint().then((fingerprint) {
      setState(() {
        if (fingerprint != null) {
          finger = fingerprint;
        } else {
          finger = false;
          saveFingerprint(finger);
        }
      });
    });
  }
}
