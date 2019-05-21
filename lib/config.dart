import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class Config extends InheritedWidget {
  Config({
    @required this.name,
    @required this.threeBotApiUrl,
    @required this.openKycApiUrl,
    @required Widget child
  }) : super(child: child);

  final String name;
  final String threeBotApiUrl;
  final String openKycApiUrl;

  static Config of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Config);
  }

  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}