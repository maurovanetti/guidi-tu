// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/common/common.dart';
import 'team_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends TrackedState<TutorialScreen> {
  final CarouselController _carouselController = CarouselController();
  late final TutorialCarousel _carousel;
  late bool _lastPage;

  @override
  void initState() {
    _carousel = TutorialCarousel(_carouselController, _onPageChanged);
    _lastPage = (TutorialCarousel.length == 1);
    super.initState();
  }

  void _onPageChanged(int page, CarouselPageChangedReason _) {
    _lastPage = (page == TutorialCarousel.length - 1);
  }

  void _moveOn() {
    if (_lastPage) {
      Navigation.replaceLast(context, () => const TeamScreen()).go();
    } else {
      _carouselController.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Come funziona?'),
      ),
      body: _carousel,
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toTeam,
        onPressed: _moveOn,
        tooltip: 'Avanti',
        icon: Icons.arrow_forward,
      ),
    );
  }
}

class TutorialCarousel extends StatelessWidget {
  const TutorialCarousel(this.controller, this.onPageChanged, {super.key});

  static const length = 4;

  static const List<String> tutorialAnimations = [
    'tutorial/Tutorial',
    'tutorial/Tutorial',
    'tutorial/Tutorial',
    'tutorial/Tutorial',
  ];

  // in Markdown format
  static const List<String> tutorialTexts = [
    """
Chi beve alcolici non guida, **troppo pericoloso**.

Ogni gruppo dovrebbe avere un **Guidatore Sobrio**.
""",
    """
Giocando a uno dei minigiochi di questa app, si stabilisce chi beve e chi guida.

**Chi arriva ultimo, guida e non beve.**
""",
    """
Ma attenzione: **chi arriva primo, può bere ma deve pagare**.

Quindi, conviene arrivare a metà classifica!
""",
    """
Penalità possibili per chi arriva primo:
* Pagare analcolici al Guidatore Sobrio?
* Offrire snack a tutti?
* Pagare la benzina?
""",
  ];

  final CarouselController controller;
  final void Function(int, CarouselPageChangedReason) onPageChanged;

  @override
  Widget build(BuildContext context) {
    assert(tutorialAnimations.length == length);
    assert(tutorialTexts.length == length);
    const carouselHeightFactor = 0.8;
    final colorScheme = Theme.of(context).colorScheme;
    return FlutterCarousel.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        var scrollController = ScrollController();
        return Padding(
          padding: StyleGuide.widePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InterstitialAnimation(
                prefix: tutorialAnimations.elementAt(itemIndex),
                repeat: double.infinity,
              ),
              const Gap(),
              Expanded(
                child: Container(
                  decoration: ShapeDecoration(
                    shape: StyleGuide.getImportantBorder(context),
                  ),
                  padding: StyleGuide.regularPadding,
                  margin: StyleGuide.regularPadding,
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView(
                      controller: scrollController,
                      padding: StyleGuide.scrollbarPadding,
                      children: [
                        MarkdownBody(
                          data: tutorialTexts.elementAt(itemIndex),
                          shrinkWrap: false,
                          styleSheet: MarkdownStyleSheet(
                            p: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        onPageChanged: onPageChanged,
        controller: controller,
        height: MediaQuery.of(context).size.height * carouselHeightFactor,
        enlargeCenterPage: true,
        slideIndicator: CircularSlideIndicator(
          currentIndicatorColor: colorScheme.primaryContainer,
          indicatorBackgroundColor: colorScheme.secondaryContainer,
        ),
      ),
    );
  }
}
