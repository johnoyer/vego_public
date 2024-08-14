import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:flutter/services.dart';
import 'package:vego_flutter_project/global_widgets.dart';
import 'package:vego_flutter_project/manual_entry/helper_functions.dart';

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
                      const SizedBox(
                        width: 100,
                        height: 70,
                      ),
                      const Spacer(),
                      buildDietInfo(context),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: isAndroid() ? InkWell(
                          onTap: () {
                            setState(() {
                              _isInfoShown = true;
                            });
                          },
                          child: questionMarkIconCard(),
                        ) : CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              _isInfoShown = true;
                            });
                          },
                          child: questionMarkIconCard(),
                        ),
                      ),
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

  TextSpan _getStyledText(final List<String> list, final String endText) {
    final List<TextSpan> spans = [];
    _localStatus = Status.none;
    for (int i=0; i<list.length; i++) {
      final String word = list[i];
      final String modifiedWord = removePrefixes(word);
      if (isRedWord(modifiedWord)) {
        _localStatus = Status.doesntFit;
        spans.add(TextSpan(text: word, style: kStyle4(Colors.red)));
      } else if (isOrangeWord(modifiedWord)) {
        if(_localStatus!=Status.doesntFit) {
          _localStatus = Status.possiblyFits;
        }
        spans.add(TextSpan(text: word, style: kStyle4(Colors.orange)));
      } else {
        if(_localStatus==Status.none) {
          _localStatus = Status.doesFit;
        }
        spans.add(TextSpan(text: word, style: kStyle4(Colors.black)));
      }
      if(i!=list.length-1) {// Do not add comma and space at the end
        spans.add(TextSpan(text: ', ', style: kStyle4(Colors.black)));
      }
    }
    spans.add(TextSpan(text: endText, style: kStyle4(Colors.black)));
    return TextSpan(children: spans);
  }

  @override
  Widget build(final BuildContext context) {
    TextSpan styledText = const TextSpan(text: '');
    DietState().setIngredients(null); // initializing ingredientinfo without setting ingredients
    List<String> newIngredientsList = [];
    if(_controller.text.endsWith(',')) {
      styledText = _getStyledText(_controller.text.substring(0, _controller.text.length - 1).split(', '), ',');
      newIngredientsList = _controller.text.substring(0, _controller.text.length - 1).split(', ');
    } else if(_controller.text.endsWith(', ')) {
      styledText = _getStyledText(_controller.text.substring(0, _controller.text.length - 2).split(', '), ', '); 
      newIngredientsList = _controller.text.substring(0, _controller.text.length - 2).split(', ');
    } else {
      styledText = _getStyledText(_controller.text.split(', '), '');
      newIngredientsList = _controller.text.split(', ');
    }

    // Delay the state setting until after run
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      DietState().setIngredients(newIngredientsList);
      DietState().setStatus(_localStatus);
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
                isAndroid() ? 
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
                    _controller.text = text;
                    setState(() {});
                  },
                  style: kStyle4(Colors.transparent),// Hide default text
                  cursorColor: Colors.black, // Keep the cursor visible
                  // cursorWidth: 2.0,
                ) 
                : Column(
                  children: [
                    CupertinoTextField(
                      enabled: !widget.isInfoShown, // disable the text field if the page info is shown
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      // buildCounter: counter,
                      textAlignVertical: const TextAlignVertical(y: -1.0),
                      controller: _controller,
                      minLines: 2,
                      maxLines: null,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'[\n\r]')
                        ),
                      ],
                      placeholder: 'Enter here; separate each ingredient with a comma and a space (not case sensitive), i.e. "Spinach, Oats, Ginger"',
                      maxLength: 800,
                      onChanged: (final text) {
                        _controller.text = text;
                        setState(() {});
                      },
                      style: kStyle4(Colors.transparent),// Hide default text
                      cursorColor: Colors.black, // Keep the cursor visible
                      // cursorWidth: 2.0,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          '${_controller.text.length}/800 characters',
                          style: const TextStyle(fontSize: 10),
                          semanticsLabel: 'character count',
                        ),
                      ],
                    ),
                  ],
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