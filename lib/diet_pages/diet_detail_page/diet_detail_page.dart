import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_classes/alldiets.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/diet_detail_page_helper_functions.dart';


class DietDetailPage extends StatefulWidget {
  final int? dietIndex;
  final Diet? fixedDiet;

  const DietDetailPage({
    this.dietIndex,
    this.fixedDiet,
  });

  @override
  State<DietDetailPage> createState() => _DietDetailPageState();
}

class _DietDetailPageState extends State<DietDetailPage> {
  bool _isInfoShown = false;

  @override
  Widget build(final BuildContext context) {
    // If the diet is variable, it is chosen from the mutable list in DietState, otherwise it is chosen from the fixed list of base diets
    final Diet diet = widget.dietIndex != null ? DietState.getDietList()[widget.dietIndex!] : widget.fixedDiet!;
    return SafeArea(
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              _isInfoShown ? Colors.black.withOpacity(0.5) : Colors.transparent, // Dark color with opacity
              BlendMode.darken,
            ),
            child: Consumer<DietState>(builder: (final context, final dietState, final _) {
              final String dietName = (diet.name=='') ? '[unnamed]' : diet.name;
              final bool showDietAttributes = diet.isPresetDietWithSubDiets() || // if the diet is a PresetDietWithSubDiets
                      (diet.isCustom() &&
                      (diet as CustomDiet).dietFeatures != null &&
                      diet.dietFeatures!.isNotEmpty); // if the diet is a CustomDiet, and it does not have a null or empty dietFeatures list
              return Scaffold(
                body: Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    libraryNavigationBar(
                      () {
                        Navigator.of(context).pop();
                      },
                      '$dietName Diet Details',
                      () {
                        setState(() {
                          _isInfoShown = true;
                        });
                      },
                      (diet is PresetDiet) ? diet.iconWidget : null
                    ),
                    showDietAttributes ? 
                    // Column(
                    //   children: [ TODO
                    //     libraryCard(
                    //       'Diet Attributes:',
                    //       TextFeatures.normal,
                    //     ),
                        SizedBox(
                          // width: 500,
                          height: 54, // TODO: need to fix this
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: diet.isPresetDietWithSubDiets() ?
                              (diet as PresetDietWithSubdiets).subDiets.length : // if the diet is a PresetDietWithSubdiets get the subDiets length
                              (diet as CustomDiet).dietFeatures!.length, // if the diet is a CustomDiet get the dietFeatures length
                            itemBuilder: (final context, final index) {
                              final String name = diet.isPresetDietWithSubDiets() ?
                                (diet as PresetDietWithSubdiets).subDiets[index].name :
                                (diet as CustomDiet).dietFeatures![index].name;
                              final Diet fixedDiet = diet.isPresetDietWithSubDiets() ?
                                (diet as PresetDietWithSubdiets).subDiets[index] :
                                (diet as CustomDiet).dietFeatures![index];
                              return LibraryButton(
                                onTap: () {
                                  if(_isInfoShown) return; // do nothing if the page info is shown
                                  Navigator.push( 
                                    context,
                                    MaterialPageRoute(
                                      builder: (final context) =>
                                          DietDetailPage(fixedDiet: fixedDiet), // the diet will be from the fixed attribute list
                                    ),
                                  );
                                },
                                child: libraryCard(
                                  name,
                                  TextFeatures.smallnormal,
                                  fancyIcon: diet.isPresetDietWithSubDiets() ?
                                    (diet as PresetDietWithSubdiets).subDiets[index].iconWidget :
                                    (diet as CustomDiet).dietFeatures![index].iconWidget 
                                ),
                              );
                            },
                          ),
                        // ),
                    //   ],
                    ) : Container(),
                    showDietAttributes ? 
                      const Padding(padding: EdgeInsets.only(top: 2)) : 
                      Container(),
                    showDietAttributes ? 
                      globalDivider() :
                      Container(),
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
                              text: diet.name.toLowerCase(),
                              style: kStyle4(ColorReturner().primary),
                            ),
                            TextSpan(
                              text: ' diet, the following items are ',
                              style: kStyle4(Colors.black)
                            ),
                            TextSpan(
                              text: diet.isProhibitive
                                  ? 'prohibited'
                                  : 'allowed',
                              style: kStyle4(diet.isProhibitive
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
                    SizedBox(
                      width: 380,
                      child: globalDivider(),
                    ),
                    itemsDisplayWidget(diet.primaryItems),
                    globalDivider(),
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
                              text: diet.isProhibitive
                                  ? 'prohibited'
                                  : 'allowed',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: diet.isProhibitive
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
                    SizedBox(
                      width: 300,
                      child: globalDivider(),
                    ),
                    itemsDisplayWidget(diet.secondaryItems),
                    !(diet.isCustom())
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: editDietButton(context, widget.dietIndex!, _isInfoShown)
                    ),
                  ],
                  )
                ),
              );
            }),
          ),
          InfoSlider(
            isInfoShown: _isInfoShown,
            title: '${(diet.name=='') ? '[unnamed]' : diet.name} Diet Info',
            info: diet.dietInfo == '' ?
            '[no diet info has been entered yet]' : diet.dietInfo,
            onClose: () => setState(() {
              _isInfoShown = false;
            }),
          ),
        ],
      ),
    );
  }
}