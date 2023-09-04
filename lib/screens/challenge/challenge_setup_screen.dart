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
  final TextEditingController _nameController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preparazione alla sfida"),
      ),
      body: WithBubbles(
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
              onPressed:
                  Navigation.push(context, () => const ChallengeScreen()).go,
              tooltip: 'Si può iniziare',
              icon: Icons.check_circle_rounded,
            )
          : null,
    );
  }
}
