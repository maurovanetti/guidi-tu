// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart'
    as carousel;
import 'package:flutter_markdown/flutter_markdown.dart';

import '/common/common.dart';
import 'team_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends TrackedState<TutorialScreen> {
  final _carouselController = carousel.FlutterCarouselController();
  late final TutorialCarousel _carousel;
  late bool _lastPage;

  @override
  void initState() {
    super.initState();
    _carousel = TutorialCarousel(_carouselController, _handleChangePage);
    _lastPage = (TutorialCarousel.length == 1);
  }

  void _handleChangePage(int page, carousel.CarouselPageChangedReason _) {
    setState(() {
      _lastPage = (page == TutorialCarousel.length - 1);
    });
  }

  void _handleMoveOn() {
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
        title: Text($.howDoesItWork),
      ),
      body: _carousel,
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toTeam,
        onPressed: _handleMoveOn,
        tooltip: $.proceed,
        icon: _lastPage ? Icons.check_circle_rounded : Icons.skip_next_rounded,
      ),
    );
  }
}

class TutorialCarousel extends StatelessWidget {
  TutorialCarousel(this.controller, this.onPageChanged, {super.key});

  static const length = 4;
  static const fps = 14;
  static const tutorialAnimation = 'tutorial/Tutorial';

  static const indicatorRadius = 10.0;
  static const indicatorSpacing = indicatorRadius * 2.5;

  final carousel.FlutterCarouselController controller;

  final pageNotifier = ValueNotifier<int>(0);

  // ignore: prefer-typedefs-for-callbacks
  final void Function(int page, carousel.CarouselPageChangedReason reason)
      onPageChanged;

  // in Markdown format
  List<String> _tutorialTexts(BuildContext context) => [
        get$(context).tutorial1,
        get$(context).tutorial2,
        get$(context).tutorial3,
        get$(context).tutorial4,
      ];

  void _handleChangeInnerPage(
      int page, carousel.CarouselPageChangedReason reason) {
    pageNotifier.value = page;
    onPageChanged(page, reason);
  }

  @override
  Widget build(BuildContext context) {
    final tutorialTexts = _tutorialTexts(context);
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
              loops: const [
                // ignore: no-magic-number
                (start: 0, end: 22),
                // ignore: no-magic-number
                (start: 81, end: 96),
                // ignore: no-magic-number
                (start: 133, end: 149),
              ],
              page: pageNotifier,
              fps: TutorialCarousel.fps,
            ),
          ),
          const Gap(),
          Expanded(
            child: carousel.FlutterCarousel.builder(
              itemCount: length,
              itemBuilder: (
                BuildContext innerContext,
                int itemIndex,
                int pageViewIndex,
              ) {
                var scrollController = ScrollController();
                return Container(
                  decoration: ShapeDecoration(
                    shape: StyleGuide.getImportantBorder(innerContext),
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
                            p: Theme.of(innerContext).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              options: carousel.FlutterCarouselOptions(
                onPageChanged: _handleChangeInnerPage,
                controller: controller,
                height: double.infinity,
                enlargeCenterPage: true,
                slideIndicator: carousel.CircularSlideIndicator(
                  slideIndicatorOptions: carousel.SlideIndicatorOptions(
                    indicatorRadius: indicatorRadius,
                    itemSpacing: indicatorSpacing,
                    currentIndicatorColor: colorScheme.primaryContainer,
                    indicatorBackgroundColor: colorScheme.secondaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
