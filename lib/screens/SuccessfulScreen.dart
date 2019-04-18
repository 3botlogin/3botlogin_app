import 'package:flutter/material.dart';

class SuccessfulScreen extends StatefulWidget {
  final Widget successfulscreen;

  SuccessfulScreen({Key key, this.successfulscreen}) : super(key: key);

  _SuccessfulScreenState createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Logged in'),
          elevation: 0.0,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Container(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Container(
                        padding: EdgeInsets.only(top: 24.0, bottom: 38.0),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle,
                                size: 42.0,
                                color: Theme.of(context).accentColor,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('You are logged in, go back to PC'),
                              SizedBox(
                                height: 60.0,
                              ),
                            ],
                          ),
                        ))))));
  }
}
