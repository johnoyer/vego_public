import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/diet_detail_page_helper_functions.dart';


class DietDetailPage extends StatelessWidget {
  final int dietIndex;

  const DietDetailPage({
    required this.dietIndex,
  });

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Consumer<DietState>(builder: (final context, final dietState, final _) {
        final String dietName = (DietState.getDietList()[dietIndex].name=='') ? '[unnamed]' : DietState.getDietList()[dietIndex].name;
        return Scaffold(
          body: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              libraryNavigationBar(
                () {
                  Navigator.of(context).pop();
                },
                '$dietName Diet Details'
              ),
              dietInfoWidget(DietState.getDietList()[dietIndex]),
              DietState.getDietList()[dietIndex].isPresetDietWithSubDiets() ? Card( // TODO:  may be a good idea to keep the listview for scrolling
                color: ColorReturner().secondaryFixed,
                shape: globalBorder,
                child: Padding( 
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      libraryCard(
                        'Diet Attributes:',
                        TextFeatures.normal,
                      ),
                      SizedBox(
                        // width: 500,
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (DietState.getDietList()[dietIndex] as PresetDietWithSubdiets).primarySubDietNameToListMap.length,
                          itemBuilder: (final context, final index) {
                            return libraryCard(
                              (DietState.getDietList()[dietIndex] as PresetDietWithSubdiets).primarySubDietNameToListMap.keys.toList()[index],
                              TextFeatures.small,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'In the ',
                        style: kStyle4(Colors.black)
                      ),
                      TextSpan(
                        text: DietState.getDietList()[dietIndex].name.toLowerCase(),
                        style: kStyle4(ColorReturner().primary),
                      ),
                      TextSpan(
                        text: ' diet, the following items are ',
                        style: kStyle4(Colors.black)
                      ),
                      TextSpan(
                        text: DietState.getDietList()[dietIndex].isProhibitive
                            ? 'prohibited'
                            : 'allowed',
                        style: kStyle4(DietState.getDietList()[dietIndex].isProhibitive
                              ? Colors.red
                              : Colors.green,),
                      ),
                      TextSpan(
                        text: ': ',
                        style: kStyle4(Colors.black)
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 380,
                child: Divider(
                  height: 5,
                  color: Colors.black,
                ),
              ),
              itemsDisplayWidget(DietState.getDietList()[dietIndex].primaryItems),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  height: 5,
                  color: Colors.black,
                ),
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
                        text: DietState.getDietList()[dietIndex].isProhibitive
                            ? 'prohibited'
                            : 'allowed',
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: DietState.getDietList()[dietIndex].isProhibitive
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
              const SizedBox(
                width: 300,
                child: Divider(
                  height: 5,
                  color: Colors.black,
                ),
              ),
              itemsDisplayWidget(DietState.getDietList()[dietIndex].secondaryItems),
              !(DietState.getDietList()[dietIndex].isCustom())
              ? Container()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: editDietButton(context, dietIndex)
              ),
            ],
            )
          ),
        );
      }),
    );
  }
}