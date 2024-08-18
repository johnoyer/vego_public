import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';

enum Stage {
  dietName,
  dietAttributes,
  dietInfo,
  dietProhibitive,
  dietPrimaryItems,
  dietSecondaryItems,
  end
}

const List<Stage> stages = [
  Stage.dietName,
  Stage.dietAttributes,
  Stage.dietInfo,
  Stage.dietProhibitive,
  Stage.dietPrimaryItems,
  Stage.dietSecondaryItems,
  Stage.end
];

class StepTitle extends StatelessWidget {
  const StepTitle({
    super.key,
    required this.slow,
    required this.counter,
    required this.title,
  });

  final bool slow;
  final int counter;
  final String title;

  @override
  Widget build(final BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.fastOutSlowIn,
      duration: slow ? const Duration(seconds: 1) : Duration.zero,
      top: counter>=1 ? -100 : 0, // Move up by 100 units
      child: libraryCard(
        title,
        TextFeatures.large,
      ),
    );
  }
}

class NextCard extends StatelessWidget {
  const NextCard({
    super.key,
    required this.slow,
    required this.counter,
    this.fieldEntered = true,
    this.bottom = false,
    this.onlyShowUponEntering = false
  });

  final bool slow;
  final int counter;
  final bool fieldEntered;
  final bool bottom;
  final bool onlyShowUponEntering;

  @override
  Widget build(final BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.easeInCubic,
      duration: slow ? const Duration(seconds: 1, milliseconds: 500)
                    : Duration.zero,
      bottom: ((counter>=2&&(!onlyShowUponEntering||fieldEntered)) ? -67 : 0), // Move down by 67 units
      child: AnimatedOpacity(
        duration: slow ? const Duration(seconds: 1)  : Duration.zero,
        opacity: ((counter>=3)&&(!onlyShowUponEntering||fieldEntered)) ? 1.0 : 0.0,
        child: libraryCard(
          fieldEntered||onlyShowUponEntering ? 'Next' : 'Skip',
          TextFeatures.normal,
          alternate: false,
        ),
      ),
    );
  }
}

Widget foundationCard() {
  return const Card(
    color: Colors.transparent,
    shadowColor: Colors.transparent,
  );
}