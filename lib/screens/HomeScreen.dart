import 'dart:async';
import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:threebotlogin/screens/LoginScreen.dart';
import 'package:threebotlogin/services/3botService.dart';
import 'package:threebotlogin/services/userService.dart';
import 'package:threebotlogin/services/firebaseService.dart';
import 'package:package_info/package_info.dart';
import 'package:threebotlogin/main.dart';
import 'package:threebotlogin/widgets/AppSelector.dart';
import 'package:uni_links/uni_links.dart';
import 'ErrorScreen.dart';
import 'RegistrationWithoutScanScreen.dart';
import 'package:threebotlogin/services/openKYCService.dart';
import 'dart:convert';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class HomeScreen extends StatefulWidget {
  final Widget homeScreen;

  HomeScreen({Key key, this.homeScreen}) : super(key: key);

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool openPendingLoginAttempt = true;
  String doubleName = '';
  var email;
  String initialLink;

  @override
  void initState() {
    getEmail().then((e) {
      setState(() {
        email = e;
      });
    });

    if (initialLink == null) {
      getLinksStream().listen((String incomingLink) {
        checkWhatPageToOpen(Uri.parse(incomingLink));
      });
    }

    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);

        webViewResizer(visible);
      },
    );
    WidgetsBinding.instance.addObserver(this);
    onActivate(true);
  }

  refresh(colorData) {
    setState(() {
      hexColor = Color(colorData);
    });
  }

  Future<void> webViewResizer(keyboardUp) async {
    double keyboardSize;
    var size = MediaQuery.of(context).size;
    print(MediaQuery.of(context).size.height.toString());

    if (keyboardUsedApp == 0) {
      Future.delayed(
          Duration(milliseconds: 100),
          () => {
                if (keyboardUp)
                  {
                    keyboardSize = MediaQuery.of(context).viewInsets.bottom,
                    flutterWebViewPlugins[keyboardUsedApp].resize(
                        Rect.fromLTWH(
                            0, 75, size.width, size.height - keyboardSize - 75),
                        instance: keyboardUsedApp),
                    print(MediaQuery.of(context).size.height.toString())
                  }
                else
                  {
                    keyboardSize = MediaQuery.of(context).viewInsets.bottom,
                    flutterWebViewPlugins[keyboardUsedApp].resize(
                        Rect.fromLTWH(0, 75, size.width, size.height - 75),
                        instance: keyboardUsedApp),
                    print(keyboardSize)
                  }
              });
    }
  }

  Future<Null> initUniLinks() async {
    initialLink = await getInitialLink();

    if (initialLink != null) {
      checkWhatPageToOpen(Uri.parse(initialLink));
    }
  }

  checkWhatPageToOpen(Uri link) {
    if (link.host == 'register') {
      logger.log('Register via link');
      openPage(RegistrationWithoutScanScreen(
        link.queryParameters,
        resetPin: false,
      ));
    }
    logger.log('==============');
  }

  openPage(page) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void checkIfThereAreLoginAttempts(dn) async {
    if (await getPrivateKey() != null && deviceId != null) {
      checkLoginAttempts(dn).then((attempt) {
        logger.log("Checking if there are login attempts.");
        try {
          if (attempt.body != '' && openPendingLoginAttempt) {
            logger.log("Found a login attempt, opening ...");
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(jsonDecode(attempt.body),
                    closeWhenLoggedIn: true),
              ),
            );
          } else {
            logger.log("We currently have no open login attempts.");
          }
        } catch (exception) {
          logger.log(exception);
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onActivate(false);
    }
  }

  Future onActivate(bool initFirebase) async {
    var buildNr = (await PackageInfo.fromPlatform()).buildNumber;
    logger.log('Current buildnumber: ' + buildNr);

    int response = await checkVersionNumber(context, buildNr);

    if (response == 1) {
      if (initFirebase) {
        initFirebaseMessagingListener(context);
      }

      String dn = await getDoubleName();

      String tmpDoubleName = await getDoubleName();

      checkIfThereAreLoginAttempts(tmpDoubleName);
      await initUniLinks();

      if (tmpDoubleName != null) {
        var sei = await getSignedEmailIdentifier();
        var email = await getEmail();

        logger.log("sei: " + sei.toString());

        if (sei != null &&
            sei.isNotEmpty &&
            email["email"] != null &&
            email["verified"]) {
          logger.log(
              "Email is verified and we have a signed email to verify this verification to a third party");

          logger.log("Email: ", email["email"]);
          logger.log("Verification status: ", email["verified"].toString());
          logger.log("Signed email: ", sei);

          // We could recheck the signed email here, but this seems to be overkill, since its already verified.
        } else {
          logger.log(
              "We are missing email information or have not been verified yet, attempting to retrieve data ...");

          logger.log("Email: ", email["email"]);
          logger.log("Verification status: ", email["verified"].toString());
          logger.log("Signed email: ", sei.toString());

          logger.log("Getting signed email from openkyc.");
          getSignedEmailIdentifierFromOpenKYC(tmpDoubleName)
              .then((response) async {
            if (response.statusCode == 404) {
              logger.log(
                  "Can't retrieve signedEmailidentifier, we need to resend email verification.");
              logger.log("Response: " + response.body);
              return;
            }

            var body = jsonDecode(response.body);
            var signedEmailIdentifier = body["signed_email_identifier"];

            if (signedEmailIdentifier != null &&
                signedEmailIdentifier.isNotEmpty) {
              logger.log(
                  "Received signedEmailIdentifier: " + signedEmailIdentifier);

              var vsei = json.decode(
                  (await verifySignedEmailIdentifier(signedEmailIdentifier))
                      .body);

              if (vsei != null &&
                  vsei["email"] == email["email"] &&
                  vsei["identifier"].toLowerCase() ==
                      tmpDoubleName.toLowerCase()) {
                logger.log(
                    "Verified signedEmailIdentifier authenticity, saving data.");
                await saveEmail(vsei["email"], true);
                await saveSignedEmailIdentifier(signedEmailIdentifier);
              } else {
                logger.log(
                    "Couldn't verify authenticity, saving unverified email.");
                await saveEmail(email["email"], false);
                await removeSignedEmailIdentifier();
              }
            } else {
              logger.log(
                  "No valid signed email has been found, please redo the verification process.");
            }
          });
        }

        if (mounted) {
          setState(() {
            doubleName = tmpDoubleName;
          });
        }
      }
    } else if (response == 0) {
      Navigator.pushReplacementNamed(context, '/error');
    } else if (response == -1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ErrorScreen(errorMessage: "Can't connect to server."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('3bot'),
        backgroundColor: hexColor,
        leading: FutureBuilder(
            future: getDoubleName(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Visibility(
                    visible: showButton,
                    child: IconButton(
                        tooltip: 'Apps',
                        icon: const Icon(Icons.apps),
                        onPressed: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          for (var flutterWebViewPlugin
                              in flutterWebViewPlugins) {
                            if (flutterWebViewPlugin != null) {
                              flutterWebViewPlugin.hide();
                              lastAppUsed = null;
                              showButton = false;
                            }
                          }
                          setState(() {
                            hexColor = Color(0xFF0f296a);
                          });
                        }));
              } else
                return Container();
            }),
        elevation: 0.0,
        actions: <Widget>[
          FutureBuilder(
              future: getDoubleName(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return IconButton(
                    icon: Icon(Icons.settings),
                    tooltip: 'Settings',
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      try {
                        for (var flutterWebViewPlugin
                            in flutterWebViewPlugins) {
                          if (flutterWebViewPlugin != null) {
                            flutterWebViewPlugin.hide();
                          }
                        }
                      } catch (Exception) {
                        print('caught something');
                      }

                      Navigator.pushNamed(context, '/preference');
                    },
                  );
                } else
                  return Container();
              }),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: FutureBuilder(
                future: getDoubleName(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return registered(context);
                  } else {
                    return notRegistered(context);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget registered(BuildContext context) {
    var appList = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[AppSelector(notifyParent: refresh)],
    );
    if (Platform.isIOS) {
      if (showApps) {
        return appList;
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You are registered.'),
            SizedBox(
              height: 20,
            ),
            Text('If you need to login you\'ll get a notification.'),
          ],
        );
      }
    } else {
      return appList;
    }
  }

  ConstrainedBox notRegistered(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
          minHeight: 250,
          minWidth: 250),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Image.asset(
            'assets/logo.png',
            height: 100.0,
          ),
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Welcome to 3Bot.', style: TextStyle(fontSize: 24)),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        CommunityMaterialIcons.account_edit,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Register Now!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                ),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).accentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        CommunityMaterialIcons.qrcode,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Scan QR!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/scan');
                  },
                ),
              ],
            ),
          ),
          Container(),
          FlatButton(
            child: Text('Recover account'),
            onPressed: () {
              Navigator.pushNamed(context, '/recover');
            },
          ),
        ],
      ),
    );
  }
}
