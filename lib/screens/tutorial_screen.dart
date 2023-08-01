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
  TutorialCarousel(this.controller, this.onPageChanged, {super.key});

  static const length = 4;

  static const String tutorialAnimation = 'tutorial/Tutorial';

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

  static const indicatorRadius = 10.0;
  static const indicatorSpacing = indicatorRadius * 2.5;

  final CarouselController controller;
  final void Function(int, CarouselPageChangedReason) onPageChanged;
  final pageNotifier = ValueNotifier<int>(0);

  _onInnerPageChange(int page, CarouselPageChangedReason reason) {
    pageNotifier.value = page;
    onPageChanged(page, reason);
  }

  @override
  Widget build(BuildContext context) {
    assert(tutorialTexts.length == length);
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: StyleGuide.widePadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SmoothSteppedAnimation(
              prefix: tutorialAnimation,
              // ignore: no-magic-number
              transitions: const [(26, 82), (97, 132)],
              page: pageNotifier,
            ),
          ),
          const Gap(),
          Expanded(
            child: FlutterCarousel.builder(
              itemCount: length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                var scrollController = ScrollController();
                return Container(
                  decoration: ShapeDecoration(
                    shape: StyleGuide.getImportantBorder(context),
                  ),
                  padding: StyleGuide.regularPadding,
                  margin: StyleGuide.regularPadding.copyWith(
                    top: 0,
                    bottom: indicatorRadius * 4,
                  ),
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
                );
              },
              options: CarouselOptions(
                onPageChanged: _onInnerPageChange,
                controller: controller,
                height: double.infinity,
                enlargeCenterPage: true,
                slideIndicator: CircularSlideIndicator(
                  indicatorRadius: indicatorRadius,
                  itemSpacing: indicatorSpacing,
                  currentIndicatorColor: colorScheme.primaryContainer,
                  indicatorBackgroundColor: colorScheme.secondaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
