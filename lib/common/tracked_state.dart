import 'package:flutter/widgets.dart';

import 'l10n/localized.dart';

abstract class TrackedState<T extends StatefulWidget> extends State<T>
    with Localized {
  @override
  void initState() {
    super.initState();
    debugPrint("--> ${widget.runtimeType}");
  }
}
