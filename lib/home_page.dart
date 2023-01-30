import 'package:flutter/material.dart';

import 'common/bubble.dart';
import 'common/custom_button.dart';
import 'common/gap.dart';
import 'common/navigation.dart';
import 'common/score_aware.dart';
import 'tutorial_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ScoreAware {
  bool _loading = true;

  DriverAndPayer? _driverAndPayer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      var driverAndPayer = await ScoreAware.retrieveCurrentDriverAndPayer();
      debugPrint("Driver=${driverAndPayer.driver}, "
          "Payer=${driverAndPayer.payer}");
      setState(() {
        _driverAndPayer = driverAndPayer;
        _loading = false;
      });
    });
  }

  Widget _buildDriverOrPayer(String? name) {
    var style = Theme.of(context).textTheme.headlineLarge!;
    if (_loading) {
      return SizedBox(
        height: style.fontSize! * style.height!,
        child: const LinearProgressIndicator(),
      );
    }
    if (name == null) {
      return Text('Scopriamolo!',
          style: style.copyWith(fontStyle: FontStyle.italic));
    }
    return Text(name, style: style.copyWith(fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guidi Tu"),
      ),
      body: WithBubbles(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Chi guida stasera?',
                  style: Theme.of(context).textTheme.headlineMedium),
              _buildDriverOrPayer(_driverAndPayer?.driver),
              const Gap(),
              Text('Chi paga stasera?',
                  style: Theme.of(context).textTheme.headlineMedium),
              _buildDriverOrPayer(_driverAndPayer?.payer),
              const Gap(),
              CustomButton(
                text: _driverAndPayer?.driver == null
                    ? 'Gioca'
                    : 'Gioca di nuovo',
                onPressed:
                    Navigation.push(context, () => const TutorialPage()).go,
              ),
              CustomButton(
                text: 'Informazioni',
                onPressed: () {
                  // TODO
                },
                important: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
