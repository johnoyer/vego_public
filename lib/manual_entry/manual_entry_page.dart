import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/manual_entry/helper_functions.dart';
import 'dart:math';

class ManualEntry extends StatefulWidget {
  const ManualEntry({super.key});

  @override
  State<ManualEntry> createState() =>
      _ManualEntry();
}

class _ManualEntry extends State<ManualEntry> {
  bool _isInfoShown = false;

  @override
  Widget build(final BuildContext context) {
    const int percentage = 80;//TODO: adjust
    return SafeArea(
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              _isInfoShown ? Colors.black.withOpacity(0.5) : Colors.transparent, // Dark color with opacity
              BlendMode.darken,
            ),
            child: Column(
              children: [
                Expanded(
                  flex: percentage,
                  child: BuildIngredientEntry(
                    cardText: 'Enter Ingredient List Below',
                    isInfoShown: _isInfoShown
                  ),
                ),
                Expanded(
                  flex: 100-percentage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(padding: EdgeInsets.only(right: 10)),
                      const SizedBox(
                        width: 60,
                        height: 70,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: min(MediaQuery.of(context).size.width, 334), // 334 is enough for the "enter ingredient to get started" text
                        child: buildDietInfo(context)
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 60,
                        child: 
                        LibraryButton(
                          onTap: () {
                            setState(() {
                              _isInfoShown = true;
                            });
                          },
                          child: questionMarkIconCard(),
                        )
                      ),
                      const Padding(padding: EdgeInsets.only(right: 10)),
                    ],
                  )
                ),
              ],
            ),
          ),
          InfoSlider(
            isInfoShown: _isInfoShown,
            title: 'Manual Entry Info',
            info: info,
            onClose: () => setState(() {
              _isInfoShown = false;
            }),
          ),
        ],
      ),
    );
  }
}

class BuildIngredientEntry extends StatefulWidget {
  final String cardText;
  final bool isInfoShown;

  const BuildIngredientEntry({
    super.key,
    required this.cardText,
    required this.isInfoShown,
  });

  @override
  State<BuildIngredientEntry> createState() => _BuildIngredientEntryState();
}

class _BuildIngredientEntryState extends State<BuildIngredientEntry> {
  late TextEditingController _controller;
  Status _localStatus = Status.none;
  final String _priorInfo = DietState().getIngredientInfo()?.persistentIngredientsList?.join(', ') ?? '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _priorInfo);
    initialize();
  }

  Future<void> initialize() async {
    await DietState.loadDietData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  } 

  @override
  Widget build(final BuildContext context) {
    late TextSpan styledText;
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      DietState().setIngredients(null); // initializing ingredientinfo without setting ingredients
    });
    List<String> newIngredientsList = [];
    late StatusStyledTextReturn statusStyledTextReturn;
    final controllerText = _controller.text.trim();
    if(controllerText.endsWith(',')) {
      statusStyledTextReturn = getStyledText(
        controllerText.substring( 0, controllerText.length - 1) // Get the styled text from everything except the last comma
          .split(','), // split the text by comma
        ','
      );
      newIngredientsList = controllerText.substring(0, controllerText.length - 1)
        .split(',') // split the text by comma
        .map((final item) => item.trim()) // trim each ingredient
        .toList(); // convert to list;
    } else {
      statusStyledTextReturn = getStyledText(
        controllerText // Get the styled text from everything
          .split(','), // split the text by comma
        ''
      );
      newIngredientsList = controllerText
        .split(',') // split the text by comma
        .map((final item) => item.trim()) // trim each ingredient
        .toList(); // convert to list;
    }
    styledText = statusStyledTextReturn.styledText;
    _localStatus = statusStyledTextReturn.status;

    // Delay the state setting until after run
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      DietState().setIngredients(newIngredientsList);
      if(controllerText.trim()=='') { // if the field is blank set status to none
        DietState().setStatus(Status.none);
      } else {
        DietState().setStatus(_localStatus);
      }
    });

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: libraryCard(widget.cardText, TextFeatures.normal),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(
            child: Stack(
              children: [
                const Padding(padding: EdgeInsets.only(top: 125),),
                TextField(
                  enabled: !widget.isInfoShown, // disable the text field if the page info is shown
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  buildCounter: counter,
                  textAlignVertical: const TextAlignVertical(y: -1.0),
                  controller: _controller,
                  minLines: 2,
                  maxLines: null,
                  decoration: InputDecoration(
                    // Border customization
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // Background color
                    filled: true,
                    fillColor: Colors.grey[200],
                    // Optional hint style
                    hintStyle: const TextStyle(color: Colors.grey),
                    // Content padding
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    hintText: 'Enter here; separate each ingredient with a comma and a space (not case sensitive), i.e. "Spinach, Oats, Ginger"',
                  ),
                  maxLength: 800,
                  onChanged: (final text) {
                    // _controller.text = text;
                    // WidgetsBinding.instance.addPostFrameCallback((final _) {
                    //   setState(() {});
                    // }); TODO: check this
                    final oldSelection = _controller.selection;

                    // Update the text and cursor position
                    setState(() {
                      _controller.value = TextEditingValue(
                        text: text,
                        selection: TextSelection.collapsed(offset: oldSelection.baseOffset),
                      );
                    });
                  },
                  style: kStyle4(Colors.transparent),// Hide default text
                  cursorColor: Colors.black, // Keep the cursor visible
                  // cursorWidth: 2.0,
                ),
                Padding(
                  padding: isAndroid() ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8) : const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  child: Column(
                    children: [
                      IgnorePointer(
                        // ignoring: true, // Prevent the RichText from blocking user input
                        child: RichText(
                          text: styledText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}