import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/helper_functions.dart';
import 'package:vego_flutter_project/diet_pages/new_diet_page/new_diet_page_helper_functions.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_classes/diet_attributes.dart';

class NewDietPage extends StatefulWidget {
  final int index; 

  const NewDietPage({super.key, required this.index});

  @override
  State<NewDietPage> createState() => _NewDietPageState();
}

class _NewDietPageState extends State<NewDietPage> with TickerProviderStateMixin {
  int _counter = 0;
  Stage stage = Stage.dietName;
  late TextEditingController _nameController;
  late TextEditingController _infoController;
  late TextEditingController _itemsController;
  late TextEditingController _secondaryItemsController;
  late PageController _pageController;
  late AnimationController _lineProgressController;
  bool _isYesSelected = false;
  bool _controllingSlowness = DietState.slowAnimations; // Used to control animation speed
  bool _animationDone = false;
  bool _fieldEntered = false;
  bool _showExpansionPanelList = false;
  bool? _enforcingProhibitive; // true if enforcing that the diet prohibits, false if enforcing the diet is allowing, null if neither
  String textFieldValue = '';
  final List<CancelableOperation> _operations = [];
  double lineProgress = 0;

  Future<void> updateStage(final Stage newStage) async {
    textFieldValue = '';
    setState(() {
      _fieldEntered = false;
      stage = newStage;
    });
    _reset();
    lineProgress+= (_enforcingProhibitive==null ? 1/6.0 : (1-1/6.0)/4);
    _lineProgressController.animateTo(
      lineProgress,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutExpo
    );
    // If the animations are "slow" there should be an animation during the page transition
    if(DietState.slowAnimations) {
      if(stage==Stage.dietAttributes || stage==Stage.dietInfo) {
        _showExpansionPanelList = false; // hides the expansionPanelList at the beginning of the transition to and from Stage.dietAttributes. this is to reduce lag caused by the expansionpanellist
      }
      await _pageController.animateToPage(
        stages.indexOf(newStage), 
        duration : const Duration(milliseconds: 800), 
        curve: Curves.easeInOutExpo
      );
      if(stage==Stage.dietAttributes) {
        _showExpansionPanelList = true; // reveals the expansionPanelList after the transition
      }
    }
    // Otherwise there should not be an animation during the page transition
    else {
      _pageController.jumpToPage(
        stages.indexOf(newStage), 
      );
    }
  }

  void _reset() {
    setState((){
      _controllingSlowness = false;
      _animationDone = false;
      _counter = 0;
    });

    // Control counter and _animationDone
    for(int i=1; i<=4; i++) {
      // _operations used so that delayed statements can be cancelled without causing error
      _operations.add(
        CancelableOperation.fromFuture(
          Future.delayed(Duration(milliseconds: DietState.slowAnimations ? i*1000-500 : 0)),
        ).then((final _) {
          if (DietState.slowAnimations) {
            _controllingSlowness = true;
          }
          if (mounted) {
            setState(() {
              if(i<3) {
                _counter = i;
              } else if(i==3) {
                if ((stage != Stage.dietName && stage != Stage.dietPrimaryItems)||_enforcingProhibitive!=null) {
                  _counter = 3;
                }
              } else {
                if ((stage != Stage.dietName && stage != Stage.dietPrimaryItems)||_enforcingProhibitive!=null) {
                  _animationDone = true;
                }
              }
            });
          }
        }),
      );
    }
  }

  @override
  void initState() {
    // super.initState();
    _reset();
    _nameController = TextEditingController();
    _infoController = TextEditingController();
    _itemsController = TextEditingController();
    _secondaryItemsController = TextEditingController();
    _pageController = PageController();

    _lineProgressController = AnimationController(
      // AnimationController can be created with `vsync: this` because of TickerProviderStateMixin
      vsync: this,
      // duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // Cancel all timing operations
    for (var operation in _operations) {
      operation.cancel();
    }
    _operations.clear();
    super.dispose();
  }

  Widget _buildPage(final Stage stage) {
    switch (stage) { 
      case Stage.dietName: // first stage
        return dietNameStage();
      case Stage.dietAttributes: // second stage
        return dietAttributesStage();
      case Stage.dietInfo: // third stage
        return dietInfoStage();
      case Stage.dietProhibitive: // fourth stage
        return dietProhibitiveStage();
      case Stage.dietPrimaryItems: // fifth stage
        return primaryDietItemsStage();
      case Stage.dietSecondaryItems: // sixth stage
        return dietSecondaryItemsStage();
      case Stage.end: // seventh stage
        return dietEndStage();
      default: 
        throw UnimplementedError('no widget');
    }
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: stages.length,
                itemBuilder: (final context, final index) {
                  return _buildPage(stages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 50),
              child: LinearProgressIndicator(
                value: _lineProgressController.value,
              ),
            )
          ],
        ),
        ),
      
    );
  }

  Widget dietEndStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            AnimatedPositioned(
              curve: Curves.easeInOutCubicEmphasized,
              duration: _controllingSlowness
                  ? const Duration(seconds: 1, milliseconds: 500)
                  : Duration.zero,
              top: _counter >= 1 ? 42 : 0, // Move down by 42 units
              child: AnimatedOpacity(
                duration: _controllingSlowness ? const Duration(seconds: 1) : Duration.zero,
                opacity: _counter >= 2
                    ? 1.0
                    : 0.0,
                child: libraryCard(
                  'Return to Diet Management',
                  TextFeatures.normal,
                  alternate: false,
                ),
              ),
            ),
            Container(
              height: 30
            ),
            AnimatedPositioned(
              curve: Curves.fastOutSlowIn,
              duration: _controllingSlowness ? const Duration(seconds: 1) : Duration.zero,
              top: _counter >= 1 ? -50 : 0, // Move up by 50 units
              child: 
              libraryCard(
                '${DietState.getDietList()[widget.index].name} diet successfully created!',
                TextFeatures.large,
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: stageSevenOnTap,
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 280,
              child: foundationCard()
            );
          }
        )
      ],
    );
  }

  void stageSevenOnTap() {
    if(_counter>=3) {
      Navigator.of(context).pop();
    }
  }

  Widget dietSecondaryItemsStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            NextCard(slow: _controllingSlowness, fieldEntered: _fieldEntered, counter: _counter),
            AnimatedOpacity(
              duration: _controllingSlowness ? const Duration(seconds: 2) : Duration.zero,
              opacity: _counter >= 1 ? 1.0 : 0.0, // Fade in
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 700,
                  child: globalTextField(
                    _secondaryItemsController,
                    (final text) {
                      textFieldValue = text;
                      setState(() {
                        _fieldEntered = true;
                      });
                    },
                    null,
                    3,
                    hintText: 'Enter ${_enforcingProhibitive!=null ? 'more' : 'the'} ingredients that may be ${DietState.getDietList()[widget.index].isProhibitive 
                      ? 'prohibited'
                      : 'allowed'} in the diet depending on circumstance with a comma and a space (not case sensitive), i.e. "Spinach, Oats, Ginger"',
                  ),
                ),
              ),
            ),
            StepTitle(slow: _controllingSlowness, counter: _counter, title: 
            'Step ${_enforcingProhibitive!=null ? '5' : '6'}: Select ${_enforcingProhibitive!=null ? 'Additional ' : ''}Foods to Possibly ${DietState.getDietList()[widget.index].isProhibitive ? 'Prohibit' : 'Allow'}'),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: stageSixOnTap,
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 75,
              child: foundationCard()
            );
          }
        )
      ],
    );
  }

  void stageSixOnTap() {
    if(_animationDone) {
      DietState().addDietItemsAll(widget.index, textFieldValue.split(', '), false)
        .then((final _) => updateStage(Stage.end));
    }
  }

  Widget primaryDietItemsStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            NextCard(slow: _controllingSlowness, fieldEntered: _fieldEntered, counter: _counter, onlyShowUponEntering: _enforcingProhibitive==null),
            AnimatedOpacity(
              duration: _controllingSlowness ? const Duration(seconds: 2) : Duration.zero,
              opacity: _counter >= 1 ? 1.0 : 0.0, // Fade in
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 700,
                  child: globalTextField(
                    _itemsController,
                    (final text) {
                      textFieldValue = text;
                      setState(() {
                        _fieldEntered = true;
                      });
                      if(_fieldEntered&&_enforcingProhibitive==null) {
                        _operations.add(
                          CancelableOperation.fromFuture(
                            Future.delayed(Duration(seconds: DietState.slowAnimations ? 1 : 0)),
                          ).then((final _) {
                            if (mounted) {
                              setState(() {
                                _counter = 3;
                              });
                            }
                          }),
                        );
                        _operations.add(
                          CancelableOperation.fromFuture(
                            Future.delayed(Duration(seconds: DietState.slowAnimations ? 2 : 0)),
                          ).then((final _) {
                            if (mounted) {
                              setState(() {
                                _animationDone = true;
                              });
                            }
                          }),
                        );
                      }
                    },
                    null,
                    3,
                    hintText:
                        'Enter ${_enforcingProhibitive!=null ? 'more' : 'the'} ingredients that you want to ${DietState.getDietList()[widget.index].isProhibitive ? 'prohibit' : 'allow'} in the diet with a comma and a space (not case sensitive), i.e. "Spinach, Oats, Ginger"',
                  ),
                ),
              ),
            ),
            StepTitle(slow: _controllingSlowness, counter: _counter, title: 
            'Step ${_enforcingProhibitive!=null ? '4' : '5'}: Select ${_enforcingProhibitive!=null ? 'Additional ' : ''}Foods to ${DietState.getDietList()[widget.index].isProhibitive ? 'Prohibit' : 'Allow'}'),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: stageFiveOnTap,
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 75,
              child: foundationCard()
            );
          }
        )
      ],
    );
  }
  
  void stageFiveOnTap() {
    if(_animationDone) {
      if(textFieldValue!=''||_enforcingProhibitive!=null) {
        DietState().addDietItemsAll(widget.index, textFieldValue.split(', '), true)
          .then((final _) => updateStage(Stage.dietSecondaryItems));
      } else {
        showErrorMessage(context, 'Diet items must be entered before continuing.');
      }
    }
  }

  Widget dietProhibitiveStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            NextCard(slow: _controllingSlowness, counter: _counter),
            AnimatedOpacity(
              duration: _controllingSlowness ? const Duration(seconds: 2) : Duration.zero,
              opacity: _counter >= 1 ? 1.0 : 0.0, // Fade in
              child: Column(
                children: [
                  const Text(
                    'This diet is one that...',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // Default color for the main text
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'allows',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: !_isYesSelected ? Colors.green : Colors.grey,
                        ),
                      ),
                      isAndroid() ? Switch(
                        value: _isYesSelected,
                        onChanged: (final newValue) {
                          setState(() {
                            _isYesSelected = newValue;
                            DietState().updateIsProhibitive(widget.index, newValue);
                          });
                        },
                        // activeTrackColor: ColorReturner().primaryFixed,
                        // activeColor: ColorReturner().primary,
                        // inactiveTrackColor: ColorReturner().secondaryFixed,
                        // inactiveThumbColor: ColorReturner().secondary, 
                        inactiveThumbColor: Colors.green,
                        inactiveTrackColor: const Color.fromARGB(78, 78, 158, 80),
                        activeColor: Colors.red,
                        activeTrackColor: const Color.fromARGB(255, 248, 176, 171),
                      ) : CupertinoSwitch(
                        value: _isYesSelected,
                        onChanged: (final newValue) {
                          setState(() {
                            _isYesSelected = newValue;
                            DietState().updateIsProhibitive(widget.index, newValue);
                          });
                        },
                        trackColor: Colors.green,
                        activeColor: Colors.red,
                      ),
                      Text(
                        'prohibits',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _isYesSelected ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '...certain foods.',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors
                          .black, // Default color for the main text
                    ),
                  ),
                ],
              ),
            ),
            StepTitle(slow: _controllingSlowness, counter: _counter, title: 'Step 4: Diet Type'),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: stageFourOnTap,
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 75,
              child: foundationCard()
            );
          }
        )
      ],
    );
  }

  void stageFourOnTap() {
    if(_animationDone) {
      updateStage(Stage.dietPrimaryItems);
    }
  }

  Widget dietInfoStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            NextCard(slow: _controllingSlowness, fieldEntered: _fieldEntered, counter: _counter),
            AnimatedOpacity(
              duration: _controllingSlowness ? const Duration(seconds: 2) : Duration.zero,
              opacity: _counter >= 1 ? 1.0 : 0.0, // Fade in
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SizedBox(
                  width: 500,
                  child: globalTextField(
                    _infoController,
                    (final value) {
                      DietState().updateDietInfo(widget.index, value);
                      setState(() {
                        _fieldEntered = true;
                      });
                    },
                    300,
                    3,
                    labelText: 'Enter some information about your diet (optional)',
                  ),
                ),
              ),
            ),
            StepTitle(slow: _controllingSlowness, counter: _counter, title: 'Step 3: Diet Information'),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: stageThreeOnTap,
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 75,
              child: foundationCard()
            );
          }
        )
      ],
    );
  }

  void stageThreeOnTap() {
    if(_animationDone) {
      if(_enforcingProhibitive!=null) {
        updateStage(Stage.dietPrimaryItems);
      } else {
        updateStage(Stage.dietProhibitive);
      }
    }
  }

  Widget dietAttributesStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 100)
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              NextCard(slow: _controllingSlowness, fieldEntered: _fieldEntered, counter: _counter, bottom: true),
              AnimatedOpacity(
                duration: _controllingSlowness ? const Duration(seconds: 2) : Duration.zero,
                opacity: _counter>=1 ? 1.0 : 0.0, // Fade in
                child: _showExpansionPanelList ? Scaffold(
                  body: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ExpansionPanelList.radio(
                      materialGapSize: 3,
                      expansionCallback: (final int index, final bool isExpanded) {
                        setState(() {
                          DietState.dietAttributesManager.dietAttributes[index].isExpanded = isExpanded;
                        });
                      },
                      children: DietState.dietAttributesManager.dietAttributes.map<ExpansionPanel>((final DietAttributeContainer dietAttributeContainer) {
                        return ExpansionPanelRadio(
                          value: dietAttributeContainer.diet.name,
                          backgroundColor: dietAttributeContainer.selectionStatus==SelectionStatus.selected 
                              ? Colors.green 
                              : dietAttributeContainer.selectionStatus==SelectionStatus.partiallySelected 
                              ? Colors.blue 
                              : ColorReturner().secondaryFixed,
                          // canTapOnHeader: false,
                          headerBuilder: (final BuildContext context, final bool isExpanded) {
                            return ListTile( 
                              title: Padding(
                                padding: const EdgeInsets.only(left: 65.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: dietAttributeContainer.diet.iconWidget,
                                    ),
                                    Text(
                                      dietAttributeContainer.diet.name,
                                      style: googleFonts(20, color: Colors.black)
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState((){
                                  if (dietAttributeContainer.selectionStatus==SelectionStatus.selected) {
                                    dietAttributeContainer.selectionStatus=SelectionStatus.notSelected;
                                  } else {
                                    dietAttributeContainer.selectionStatus=SelectionStatus.selected;
                                  }
                                  _fieldEntered = true;
                                });
                              }
                            );
                          },
                          body: ListTile(
                            title: Center(
                              child: dietInfoWidget(dietAttributeContainer.diet)
                            ),
                            subtitle: dietAttributeContainer.expandedView!=null ? dietAttributeContainer.expandedView!(
                              dietAttributeContainer.diet, 
                              dietAttributeContainer.selectionStatus, 
                              (final selectionStatus, final itemSelectedList) {
                                setState(() {
                                  dietAttributeContainer.selectionStatus = selectionStatus;
                                  dietAttributeContainer.itemSelectedList = itemSelectedList;
                                  _fieldEntered = true;
                                });
                              },
                            ) : null
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ) : Container(),
              ),
              StepTitle(slow: _controllingSlowness, counter: _counter, title: 'Step 2: Select Diet Attributes'),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: () async => await stageTwoOnTap(),
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 75,
              child: foundationCard()
            );
          }
        )
      ],
    );
  }

  Future<void> stageTwoOnTap() async {
    if(_animationDone) {
      for(DietAttributeContainer dietAttributeContainer in DietState.dietAttributesManager.dietAttributes) {
        if(dietAttributeContainer.selectionStatus!=SelectionStatus.notSelected){
          if(dietAttributeContainer.diet.isProhibitive) { // prohibitive diet
            if(!(_enforcingProhibitive==null||_enforcingProhibitive==true)) throw Exception('enforcingProhibitive issue');
            _enforcingProhibitive = true;
          } else { // allowing diet
            if(!(_enforcingProhibitive==null||_enforcingProhibitive==false)) throw Exception('enforcingProhibitive issue');
            _enforcingProhibitive = false;
          }
          DietState().updateIsProhibitive(widget.index, _enforcingProhibitive!);
          //TODO
          // await DietState().addDietItemsFromDiet(widget.index, dietAttributeContainer.diet, dietAttributeContainer.itemSelectedList);
        }
        dietAttributeContainer.selectionStatus=SelectionStatus.notSelected;
      }
      updateStage(Stage.dietInfo);
    }
  }

  Widget dietNameStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            NextCard(slow: _controllingSlowness, fieldEntered: _fieldEntered, counter: _counter, onlyShowUponEntering: true),
            AnimatedOpacity(
              duration: _controllingSlowness ? const Duration(seconds: 2) : Duration.zero,
              opacity: _counter>=1 ? 1.0 : 0.0, // Fade in
              child: SizedBox(
                width: 300,
                child: globalTextField(
                  _nameController,
                  (final text) {
                    textFieldValue = text;
                    setState(() {
                      _fieldEntered = true;
                    });
                    _operations.add(
                      CancelableOperation.fromFuture(
                        Future.delayed(Duration(seconds: DietState.slowAnimations ? 1 : 0)),
                      ).then((final _) {
                        if (mounted) {
                          setState(() {
                            _counter = 3;
                          });
                        }
                      }),
                    );
                    _operations.add(
                      CancelableOperation.fromFuture(
                        Future.delayed(Duration(seconds: DietState.slowAnimations ? 2 : 0)),
                      ).then((final _) {
                        if (mounted) {
                          setState(() {
                            _animationDone = true;
                          });
                        }
                      }),
                    );
                  },
                  30,
                  1,
                  labelText: 'Enter the name of your diet',
                ),
              ),
            ),
            StepTitle(slow: _controllingSlowness, counter: _counter, title: 'Step 1: Name Your Diet'),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        LibraryButton(
          onTap: () async => await stageOneOnTap(),
          childBuilder: (final double animationValue) {
            return SizedBox(
              height: 60,
              width: 75,
              child: foundationCard(),
            );
          }
        )
      ],
    );
  }

  Future<void> stageOneOnTap() async {
    if(_animationDone) {
      final bool? duplicateName = await DietState().updateDietName(widget.index, textFieldValue);
      if(duplicateName==null) {
        updateStage(Stage.dietAttributes);
      } else if(duplicateName==true) {
        if(!mounted) return;
        showErrorMessage(context, 'The diet name "$textFieldValue" already exists.');
      } else if(duplicateName==false) {
        if(!mounted) return;
        showErrorMessage(context, 'The diet must be named before continuing.');
      }
    }
  }
}