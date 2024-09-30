// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'challenge_screen.dart';

class ChallengeSetupScreen extends StatefulWidget {
  const ChallengeSetupScreen({super.key});

  @override
  ChallengeSetupScreenState createState() => ChallengeSetupScreenState();
}

class ChallengeSetupScreenState extends State<ChallengeSetupScreen>
    with Localized {
  final _nameController = TextEditingController();

  bool _readyToConfirm = false;

  bool? _sober;

  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() {
      var name = db.getString(Persistence.challengerKey);
      if (name.isNotEmpty) {
        _nameController.text = name;
        _readyToConfirm = true;
      }
    });
  }

  void _handleNameChange(String name) {
    setState(() {
      _readyToConfirm = name.isNotEmpty;
    });
  }

  void _showSensorAlert() {
    unawaited(showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: WidgetKeys.sensorAlert,
        title: Text($.prepareForChallenge),
        content: Text($.placePhoneHorizontally),
        actions: [
          TextButton(
            key: WidgetKeys.acknowledgeSensorAlert,
            // ignore: prefer-correct-handler-name
            onPressed: _startChallenge,
            child: Text($.done),
          ),
        ],
      ),
    ));
  }

  void _startChallenge() {
    db.set(Persistence.challengerKey, _nameController.text);
    if (mounted) {
      Navigation.push(
        context,
        () => ChallengeScreen(
          name: _nameController.text,
          sober: _sober!,
        ),
      ).go();
    }
  }

  void _handleSobernessChange(bool? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _sober = value;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text($.preparingForChallenge),
      ),
      body: WithBubbles(
        key: const Key('bubbles'),
        behind: true,
        child: Padding(
          padding: StyleGuide.widePadding,
          child: SqueezeOrScroll(
            squeeze: true,
            centralChild: Column(
              children: [
                Text($.whatsYourName),
                PlayerNameField(
                  controller: _nameController,
                  themeData: Theme.of(context),
                  onChanged: _handleNameChange,
                  $: get$(context),
                ),
                const Gap(),
                ListTile(
                  title: Text($.iHaveDrunk),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: _sober,
                    onChanged: _handleSobernessChange,
                  ),
                ),
                ListTile(
                  title: Text($.iHaveNotDrunk),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: _sober,
                    onChanged: _handleSobernessChange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _readyToConfirm && _sober != null
          ? CustomFloatingActionButton(
              key: WidgetKeys.toChallenge,
              // ignore: prefer-correct-handler-name
              onPressed: _showSensorAlert,
              tooltip: $.youCanStart,
              icon: Icons.check_circle_rounded,
            )
          : null,
    );
  }
}
