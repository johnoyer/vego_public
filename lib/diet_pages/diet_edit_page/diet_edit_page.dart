import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_pages/diet_edit_page/diet_edit_page_helper_functions.dart';

class DietEditPage extends StatefulWidget {
  final int dietIndex;

  const DietEditPage({
    required this.dietIndex,
  });

  @override
  State<DietEditPage> createState() => _DietEditPageState();
}

class _DietEditPageState extends State<DietEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dietInfoController = TextEditingController();
  String dietName = '';
  String dietInfo = '';
  bool dietIsProhibitive = false;
  List<String> newPrimaryItems = [];
  List<String> newSecondaryItems = [];

  @override
  void initState() {
    super.initState();
    _nameController.text = DietState.getDietList()[widget.dietIndex].name;
    _dietInfoController.text = DietState.getDietList()[widget.dietIndex].dietInfo;
    dietName = DietState.getDietList()[widget.dietIndex].name;
    dietInfo = DietState.getDietList()[widget.dietIndex].dietInfo;
    dietIsProhibitive = DietState.getDietList()[widget.dietIndex].isProhibitive;
    newPrimaryItems = capitalizeFirstLetterOfEveryWord(DietState.getDietList()[widget.dietIndex].primaryItems);
    newSecondaryItems = capitalizeFirstLetterOfEveryWord(DietState.getDietList()[widget.dietIndex].secondaryItems);
  }
  
  String getDietNameUpperCase() {
    return dietName == '' ? '[unnamed]' : dietName;
  }

  String getDietNameLowerCase() {
    return dietName == '' ? '[unnamed]' : dietName.toLowerCase();
  }

  int addDietItem(final bool primary) {
    primary ? newPrimaryItems.add('') : newSecondaryItems.add('');
    return primary ? newPrimaryItems.length - 1 : newSecondaryItems.length - 1;
  }

  bool? updateDietItem(final int itemIndex, final String itemName, final bool primary) {
    if(lowerCaseEveryWord(newPrimaryItems).contains(itemName.toLowerCase())) {
      return true;
    } 
    if(lowerCaseEveryWord(newSecondaryItems).contains(itemName.toLowerCase())) {
      return false;
    }
    if(primary) { 
      newPrimaryItems[itemIndex] = itemName;
    } else { 
      newSecondaryItems[itemIndex] = itemName;
    }
    return null;
  }

  void removeDietItem(final int itemIndex, final bool primary) {
    primary ? newPrimaryItems.removeAt(itemIndex) : newSecondaryItems.removeAt(itemIndex);
  }
  
  void onPressedRemoveFunction(final int index, final bool primary) {
    setState((){
      removeDietItem(index, primary);
    });
  }

  Future<void> onPressedSaveFunction() async {
    await DietState().updateDietInfo(widget.dietIndex, dietInfo);
    await DietState().updateIsProhibitive(widget.dietIndex, dietIsProhibitive);
    await DietState().updateDietItems(widget.dietIndex, newPrimaryItems, true);
    await DietState().updateDietItems(widget.dietIndex, newSecondaryItems, false);
    final bool? duplicateName = await DietState().updateDietName(widget.dietIndex, dietName);
    if(duplicateName==true) {
      if (!mounted) return; 
      showErrorMessage(context, 'The diet name "$dietName" already exists.');
    } else if(duplicateName==false) {
      if (!mounted) return; 
      showErrorMessage(context, 'The diet must be named.');
    } else {
      if (!mounted) return; 
      showAlert(context, 1, 'Diet Successfuly Saved!');
    }
  }

  void _showItemEditDialog(final int index, final bool adding, final bool primary) {
    String editedText = primary ? newPrimaryItems[index] : newSecondaryItems[index];
    
    void onPressedEditingFunction() {
      final bool? itemInPrimaryItems = updateDietItem(index, editedText, primary);
      setState(() {
        if (editedText == '' || itemInPrimaryItems!=null) {
          removeDietItem(index, primary);
        }
      });    
      Navigator.of(context).pop();
      if(itemInPrimaryItems!=null&&editedText!= '') {
        showErrorMessage(context, 'This item is already in the \'${!itemInPrimaryItems ? 'may be ' : ''}${dietIsProhibitive ? 'prohibited' : 'allowed'}\' items section of the diet');
      }
    }

    isAndroid() ? showDialog(
      context: context,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: adding ? const Text('Add Item') : const Text('Edit Item'),
          content: globalTextField(
            TextEditingController(text: editedText),
            (final text) {
              editedText = text;
            },
            50,
            1,
            labelText: 'Item Name',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop()
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () => onPressedEditingFunction()
            ),
          ],
        );
      },
    ) : showCupertinoDialog(
      context: context,
      builder: (final BuildContext context) {
        return CupertinoAlertDialog(
          title: adding ? const Text('Add Item') : const Text('Edit Item'),
          content: globalTextField(
            TextEditingController(text: editedText),
            (final text) {
              editedText = text;
            },
            50,
            1,
            labelText: 'Item Name',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop()
            ),
            CupertinoDialogAction(
              child: const Text('Save'),
              onPressed: () => onPressedEditingFunction()
            ),
          ],
        );
      },
    );
    
  }

  void backButtonOnPressed() {
    // Check whether anything has changed
    final bool nameChanged = dietName != DietState.getDietList()[widget.dietIndex].name;
    final bool infoChanged = dietInfo != DietState.getDietList()[widget.dietIndex].dietInfo;
    final bool prohibitiveChanged = dietIsProhibitive != DietState.getDietList()[widget.dietIndex].isProhibitive;

    // Item by item check is necessary because list comparison compares if the objects are equal not the contents
    bool primaryItemsChanged = false;
    final List<String> oldPrimaryItems = capitalizeFirstLetterOfEveryWord(DietState.getDietList()[widget.dietIndex].primaryItems);
    if(oldPrimaryItems.length!=newPrimaryItems.length) {
      primaryItemsChanged = true;
    } else {
      for(int i=0; i<oldPrimaryItems.length; i++) {
        if(oldPrimaryItems[i]!=newPrimaryItems[i]) {
          primaryItemsChanged = false;
        }
      }
    }

    bool secondaryItemsChanged = false;
    final List<String> oldSecondaryItems = capitalizeFirstLetterOfEveryWord(DietState.getDietList()[widget.dietIndex].secondaryItems);
    if(oldSecondaryItems.length!=newSecondaryItems.length) {
      secondaryItemsChanged = true;
    } else {
      for(int i=0; i<oldSecondaryItems.length; i++) {
        if(oldSecondaryItems[i]!=newSecondaryItems[i]) {
          secondaryItemsChanged = false;
        }
      }
    }

    final bool somethingHasChanged = nameChanged || infoChanged || prohibitiveChanged || primaryItemsChanged || secondaryItemsChanged;

    if(!somethingHasChanged) {
      Navigator.of(context).pop();
    } else {
      isAndroid () ? showDialog(
        context: context,
        builder: (final BuildContext context) {
          return AlertDialog(
            title: const Text('Notice'),
            content: const Text(
              'You have unsaved changes, are you sure you want to proceed?'
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
            ],
          );
        }
      ): showCupertinoDialog(
        context: context,
        builder: (final BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Notice'),
            content: const Text(
              'You have unsaved changes, are you sure you want to proceed?'
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              libraryNavigationBar(
                backButtonOnPressed, 
                '${getDietNameUpperCase()} Diet Editing',
                null
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  libraryCard('Name:', TextFeatures.normal),
                  SizedBox(
                    width: 200,
                    child: globalTextField(
                      _nameController, 
                      (final text) {
                        setState(() {
                          dietName = text;
                        });
                      },
                      30, 
                      1,
                      hintText: 'Enter name here', 
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  libraryCard('Diet Info:', TextFeatures.normal, icon: Icons.question_mark),
                  SizedBox(
                    width: 400,
                    child: globalTextField(
                      _dietInfoController, 
                      (final text) {
                        setState(() {
                          dietInfo = text;
                        });
                      }, 
                      300, 
                      2,
                      hintText: 'Enter some information about the diet here (optional)', 
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  libraryCard(
                    'Toggle between allowing and prohibiting the listed foods:', 
                    TextFeatures.small,
                    alternate: true
                  ),
                  isAndroid() ? Switch(
                    activeColor: Colors.green,
                    activeTrackColor: const Color.fromARGB(78, 78, 158, 80),
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: const Color.fromARGB(255, 248, 176, 171),
                    value: !dietIsProhibitive,
                    onChanged: (final newValue) {
                      setState(() {
                        dietIsProhibitive = !newValue;
                      });
                    },
                  ) : CupertinoSwitch(
                    trackColor: Colors.red,
                    activeColor: Colors.green,
                    value: !dietIsProhibitive,
                    onChanged: (final newValue) {
                      setState(() {
                        dietIsProhibitive = !newValue;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText( // In the ____ the following items are ____
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'In the ',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: getDietNameLowerCase(),
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: ColorReturner().primary,
                        ),
                      ),
                      const TextSpan(
                        text: ' diet, the following items are ',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: dietIsProhibitive
                            ? 'prohibited'
                            : 'allowed',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: dietIsProhibitive
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                      const TextSpan(
                        text: ': ',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded( // List of items
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 1.0, // Horizontal spacing between items
                      runSpacing: 1.0, // Vertical spacing between lines
                      children: [
                        ...List.generate(
                          newPrimaryItems.length,
                          (final index) {
                            return LibraryButton(
                              onTap: () => _showItemEditDialog(index, false, true),
                              child: Card(
                                color: ColorReturner().primaryFixed,
                                shape: globalBorder,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(newPrimaryItems[index]),
                                      LibraryButton(
                                        onTap: () => onPressedRemoveFunction(index, true),
                                        child: const Icon(
                                          Icons.close,
                                          size: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Card(
                          shape: globalBorder,
                          color: ColorReturner().primaryFixed,
                          child: LibraryButton(
                            onTap: () {
                              final int newIndex = addDietItem(true);
                              _showItemEditDialog(newIndex, true, true);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Icon(
                                Icons.add,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: globalDivider(),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'The following items ',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black, 
                          ),
                        ),
                        const TextSpan(
                          text: 'may be ',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                        TextSpan(
                          text: dietIsProhibitive
                              ? 'prohibited'
                              : 'allowed',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: dietIsProhibitive
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                        const TextSpan(
                          text: ': ',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                Colors.black, // Default color for the main text
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded( // List of secondary items
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 1.0, // Horizontal spacing between items
                      runSpacing: 1.0, // Vertical spacing between lines
                      children: [
                        ...List.generate(
                          newSecondaryItems.length,
                          (final index) {
                            return LibraryButton(
                              onTap: () => _showItemEditDialog(index, false, false),
                              child: Card(
                                shape: globalBorder,
                                color: ColorReturner().primaryFixed,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(newSecondaryItems[index]),
                                      LibraryButton(
                                        onTap: () => onPressedRemoveFunction(index, false),
                                        child: const Icon(
                                          Icons.close,
                                          size: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Card(
                          shape: globalBorder,
                          color: ColorReturner().primaryFixed,
                          child: LibraryButton(
                            onTap: () {
                              final int newIndex = addDietItem(false);
                              _showItemEditDialog(newIndex, true, false);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Icon(
                                Icons.add,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LibraryButton(
                    onTap: () async => onPressedSaveFunction(),
                    child: saveDietCard(),
                  ),
                  LibraryButton(
                    onTap: () => _showDietRemovalDialog(context),
                    child: removeDietCard()
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  
  void _showDietRemovalDialog(final BuildContext context) {
    void onPressedDietRemovalFunction() {
      Navigator.of(context).pop();
      Navigator.pop(context);
      Navigator.pop(context);
      DietState().removeDiet(widget.dietIndex);
    }

    isAndroid() ? showDialog(
      context: context,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: Text('Delete $dietName Diet'),
          content: Text(
            'Are you sure you want to delete the $dietName diet? This action is permanent and cannot be undone.'
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => onPressedDietRemovalFunction(),
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    ) : showCupertinoDialog(
      context: context,
      builder: (final BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete $dietName Diet'),
          content: Text(
            'Are you sure you want to delete the $dietName diet? This action is permanent and cannot be undone.'
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => onPressedDietRemovalFunction(),
              child: const Text('Yes'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
