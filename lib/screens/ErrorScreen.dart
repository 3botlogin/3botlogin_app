import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:threebotlogin/main.dart';

class ErrorScreen extends StatefulWidget {
  final Widget errorScreen;
  final String errorMessage;
  final bool retryButton;
  ErrorScreen({Key key, this.errorScreen, this.retryButton = false, this.errorMessage = '', })
      : super(key: key);
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  var version = '0.0.0';

  @override
  void initState() {
    super.initState();
    hideWebviews();
    PackageInfo.fromPlatform().then((packageInfo) => {
          setState(() {
            version = packageInfo.version;
          })
        });
  }

  void hideWebviews() {
    for (var flutterWebViewPlugin in flutterWebViewPlugins) {
      if (flutterWebViewPlugin != null) {
        flutterWebViewPlugin.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
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
                    topRight: Radius.circular(20.0))),
            child: Container(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: Container(
                  padding: EdgeInsets.only(top: 24.0, bottom: 38.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: Container(),
                        ),
                        Icon(
                          Icons.warning,
                          size: 42.0,
                          color: Theme.of(context).errorColor,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(width: MediaQuery.of(context).size.width * 0.75, 
                        child: Text(widget.errorMessage.isEmpty
                            ? 'Please update the app before continuing'
                            : widget.errorMessage, textAlign: TextAlign.center),),
                        
                        SizedBox(
                          height: 40.0,
                        ),
                       Container (
                          child : (widget.retryButton) ?
                          new OutlineButton.icon(
                            borderSide: BorderSide(color: Colors.grey),
                            padding: EdgeInsets.all(15),
                            icon: Icon(Icons.refresh),
                            label: Text('Retry', style: TextStyle(fontSize: 15.0),),
                            onPressed: () { Navigator.pop(context); },
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25.0))
                          ): new Container(),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text('v ' + version + (isInDebugMode ? '-DEBUG' : '')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
