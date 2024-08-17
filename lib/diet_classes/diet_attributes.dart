import 'package:flutter/material.dart';

import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/library/library.dart';
import 'package:vego_flutter_project/global_widgets/global_widgets.dart';
import 'package:vego_flutter_project/preset_diets/preset_diets_container.dart';


enum SelectionStatus {
  selected,
  partiallySelected,
  notSelected
}

class DietAttributesManager {
  List<DietAttributeContainer> dietAttributes = [
    DietAttributeContainer(
      diet: Vegan(),
    ),
    DietAttributeContainer(
      diet: Vegetarian(),
    ),
    DietAttributeContainer(
      diet: GlutenFree(),
    ),
    DietAttributeContainer(
      diet: AdditiveFree(),
    ),
    DietAttributeContainer(
      diet: FoodDyeFree(),
    ),
    DietAttributeContainer(
      diet: TreeNutFree(),
      expandedView: (final diet, final selectionStatus, final onUpdateSelectedItems) => OnlyIngredientsExpandedView(
        diet: diet,
        selectionStatus: selectionStatus,
        onUpdateSelectedItems: onUpdateSelectedItems,
      ),
    ),
    DietAttributeContainer(
      diet: SeaFoodFree(),
      expandedView: (final diet, final selectionStatus, final onUpdateSelectedItems) => OnlySubdietsExpandedView(
        diet: diet as PresetDietWithSubdiets,
        selectionStatus: selectionStatus,
        onUpdateSelectedItems: onUpdateSelectedItems,
      ),
    )
  ];
}

class DietAttributeContainer {
  final PresetDiet diet;
  final Widget Function(PresetDiet, SelectionStatus, void Function(SelectionStatus, List<bool>?))? expandedView;

  SelectionStatus selectionStatus;
  bool isExpanded;

  List<bool>? itemSelectedList;

  DietAttributeContainer({
    required this.diet,
    this.isExpanded = false,
    this.selectionStatus = SelectionStatus.notSelected,
    this.expandedView,
  });
}

class OnlyIngredientsExpandedView extends StatefulWidget {
  final PresetDiet diet;
  final SelectionStatus selectionStatus;
  final void Function(SelectionStatus, List<bool>?) onUpdateSelectedItems;

  const OnlyIngredientsExpandedView({
    required this.diet,
    required this.selectionStatus,
    required this.onUpdateSelectedItems,
  });

  @override
  State<OnlyIngredientsExpandedView> createState() => _OnlyIngredientsExpandedViewState();
}

class _OnlyIngredientsExpandedViewState extends State<OnlyIngredientsExpandedView> {
  late List<bool> itemSelectedList;

  @override
  void initState() {
    super.initState();
    itemSelectedList = List.filled(widget.diet.primaryItems.length, false);
  }

  void initializeItemSelectedList() {
    if(widget.selectionStatus!=SelectionStatus.partiallySelected) {
      itemSelectedList = List.filled(widget.diet.primaryItems.length, widget.selectionStatus==SelectionStatus.selected);
    }
  }

  void updateParentSelectionStatus() {
    final SelectionStatus selectionStatus = itemSelectedList.every((final selected) => selected) 
      ? SelectionStatus.selected 
      : itemSelectedList.every((final selected) => !selected)
      ? SelectionStatus.notSelected
      : SelectionStatus.partiallySelected;
    widget.onUpdateSelectedItems(selectionStatus,itemSelectedList);
  }

  @override
  void didUpdateWidget(covariant final OnlyIngredientsExpandedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionStatus != widget.selectionStatus) {
      print('arrived');
      initializeItemSelectedList();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        libraryCard(
          'Select Specific Ingredients to Prohibit below',
          TextFeatures.small,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.diet.primaryItems.length,
          itemBuilder: (final context, final index) {
            return InkWell(
              onTap: () {
                setState(() {
                  itemSelectedList[index] = !itemSelectedList[index];
                  updateParentSelectionStatus();
                });
              },
              child: Ink(
                color: itemSelectedList[index] ? Colors.green : ColorReturner().secondaryFixed,
                child: Center(
                  child: Text(widget.diet.primaryItems[index]),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class OnlySubdietsExpandedView extends StatefulWidget {
  final PresetDietWithSubdiets diet;
  final SelectionStatus selectionStatus;
  final void Function(SelectionStatus, List<bool>?) onUpdateSelectedItems;

  const OnlySubdietsExpandedView({
    required this.diet,
    required this.selectionStatus,
    required this.onUpdateSelectedItems,
  });

  @override
  State<OnlySubdietsExpandedView> createState() => _OnlySubdietsExpandedViewState();
}

class _OnlySubdietsExpandedViewState extends State<OnlySubdietsExpandedView> {
  late List<bool> itemSelectedList;

  @override
  void initState() {
    super.initState();
    initializeItemSelectedList();
  }

  void initializeItemSelectedList() {
    if(widget.selectionStatus!=SelectionStatus.partiallySelected) {
      itemSelectedList = List.filled(widget.diet.primarySubDietNameToListMap.length, widget.selectionStatus==SelectionStatus.selected);
    }
  }

  void updateParentSelectionStatus() {
    final SelectionStatus selectionStatus = itemSelectedList.every((final selected) => selected) 
      ? SelectionStatus.selected 
      : itemSelectedList.every((final selected) => !selected)
      ? SelectionStatus.notSelected
      : SelectionStatus.partiallySelected;
    widget.onUpdateSelectedItems(selectionStatus,itemSelectedList);
  }

  @override
  void didUpdateWidget(covariant final OnlySubdietsExpandedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionStatus != widget.selectionStatus) {
      initializeItemSelectedList();
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        libraryCard(
          'Select Subdiets Below',
          TextFeatures.small,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.diet.primarySubDietNameToListMap.length,
          itemBuilder: (final context, final index) {
            return InkWell(
              onTap: () {
                setState(() {
                  itemSelectedList[index] = !itemSelectedList[index];
                  updateParentSelectionStatus();
                });
              },
              child: Ink(
                color: itemSelectedList[index] ? Colors.green : ColorReturner().secondaryFixed,
                child: Center(
                  child: Text(widget.diet.primarySubDietNameToListMap.keys.toList()[index]),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
