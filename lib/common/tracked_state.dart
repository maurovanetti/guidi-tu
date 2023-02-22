import 'package:flutter/widgets.dart';

abstract class TrackedState<T extends StatefulWidget> extends State<T> {
  @override
  void initState() {
    super.initState();
    debugPrint("--> ${widget.runtimeType}");
  }
}
