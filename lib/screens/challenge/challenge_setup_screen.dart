// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/common/common.dart';
import 'challenge_screen.dart';

class ChallengeSetupScreen extends StatefulWidget {
  const ChallengeSetupScreen({Key? key}) : super(key: key);

  @override
  ChallengeSetupScreenState createState() => ChallengeSetupScreenState();
}

class ChallengeSetupScreenState extends State<ChallengeSetupScreen> {
  final _nameController = TextEditingController();

  bool _readyToConfirm = false;

  bool? _sober;

  @override
  void initState() {
    super.initState();
    Delay.atNextFrame(() async {
      var prefs = await SharedPreferences.getInstance();
      var name = prefs.getString(Persistence.challengerKey) ?? '';
      if (name.isNotEmpty) {
        _nameController.text = name;
        _readyToConfirm = true;
      }
    });
  }

  void _updateReadyToConfirm(String name) {
    setState(() {
      _readyToConfirm = name.isNotEmpty;
    });
  }

  Future<void> _startChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    var _ = prefs.setString(Persistence.challengerKey, _nameController.text);
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preparazione alla sfida"),
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
                const Text('Come ti chiami?'),
                PlayerNameField(
                  controller: _nameController,
                  themeData: Theme.of(context),
                  onChanged: _updateReadyToConfirm,
                ),
                const Gap(),
                ListTile(
                  title: const Text('Ho bevuto alcolici'),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: _sober,
                    onChanged: (value) {
                      setState(() {
                        _sober = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Non ho bevuto alcolici'),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: _sober,
                    onChanged: (value) {
                      setState(() {
                        _sober = value!;
                      });
                    },
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
              onPressed: _startChallenge,
              tooltip: 'Si può iniziare',
              icon: Icons.check_circle_rounded,
            )
          : null,
    );
  }
}
