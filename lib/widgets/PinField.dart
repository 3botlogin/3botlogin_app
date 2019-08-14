import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class PinField extends StatefulWidget {
  final Widget pinField;
  final int pinLength = 4;
  final callback;
  final callbackParam;
  PinField({Key key, this.pinField, this.callback, this.callbackParam})
      : super(key: key);
  _PinFieldState createState() => _PinFieldState();
}

class _PinFieldState extends State<PinField> {
  List<String> input = List();

  Widget buildTextField(int i, BuildContext context) {
    const double maxSize = 7;
    double size = input.length > i ? maxSize : 1;
    double margin = (maxSize * 2 - size) / 2;
    return AnimatedContainer(
      margin: EdgeInsets.all(margin),
      height: size,
      width: size,
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
      duration: Duration(milliseconds: 100),
      curve: Curves.bounceInOut,
    );
  }

  Widget buildNumberPin(String buttonText, BuildContext context,
      {Color backgroundColor: Colors.blueGrey}) {
    var onPressedMethod = () => handleInput(buttonText);
    if (buttonText == 'OK')
      onPressedMethod = input.length >= widget.pinLength ? () => onOk() : null;
    if (buttonText == 'C')
      onPressedMethod = input.length >= 1 ? () => onClear() : null;
    return Container(
        padding: EdgeInsets.only(top: 12, bottom: 12),
        child: Center(
            child: RawMaterialButton(
          padding: EdgeInsets.all(12),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: onPressedMethod,
          fillColor: backgroundColor,
          shape: CircleBorder(),
        )));
  }

  Widget generateNumbers(BuildContext context) {
    List<String> possibleInput = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'C',
      '0',
      'OK'
    ];
    List<Widget> pins = List.generate(possibleInput.length, (int i) {
      String buttonText = possibleInput[i];
      if (buttonText == 'C')
        return buildNumberPin(possibleInput[i], context,
            backgroundColor:
                input.length >= 1 ? Colors.yellow[700] : Colors.yellow[200]);
      else if (buttonText == 'OK')
        return buildNumberPin(possibleInput[i], context,
            backgroundColor: input.length >= widget.pinLength
                ? Colors.green[600]
                : Colors.green[100]);
      else
        return buildNumberPin(possibleInput[i], context);
    });
    return Container(
      width: double.infinity,
      child: Center(
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: pins.take(3).toList()),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: pins.skip(3).take(3).toList()),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: pins.skip(6).take(3).toList()),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: pins.skip(9).take(3).toList()),
          ],
        ),
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.pinLength, (int i) {
      return buildTextField(i, context);
    });

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      generateTextFields(context),
      SizedBox(height: 25),
      generateNumbers(context),
    ]);
  }

  void onOk() {
    print(widget.callback);
    print(widget.callbackParam);

    HapticFeedback.mediumImpact();
    String pin = "";
    input.forEach((char) => pin += char);
    logger.log(pin);
    if (widget.callbackParam != null) {
      widget.callback(pin, widget.callbackParam);
    } else {
      widget.callback(pin);
    }

    setState(() {
      input = List();
    });
  }

  void onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      input.removeLast();
    });
  }

  void handleInput(String buttonText) async {
    if (input.length < widget.pinLength) {
      HapticFeedback.lightImpact();
      setState(() {
        input.add(buttonText);
      });
    }
  }
}
