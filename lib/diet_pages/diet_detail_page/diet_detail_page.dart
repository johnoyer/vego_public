import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/helper_functions.dart';


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
      child: Scaffold(
        backgroundColor: ColorReturner().backGroundColor,
        body: Stack(
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
                return Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    libraryNavigationBar(
                      () {
                        Navigator.of(context).pop();
                      },
                      '$dietName Diet',
                      () {
                        setState(() {
                          _isInfoShown = true;
                        });
                      },
                      (diet is PresetDiet) ? Container(
                        decoration: BoxDecoration(
                        boxShadow: [
                          globalShadow(false, color: Colors.black)
                        ],
                        shape: BoxShape.circle
                      ),
                        child: diet.iconWidget
                      ) : null
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
                      height: 60, // TODO: need to fix this
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
                            childBuilder: (final double animationValue) {
                              return libraryCard(
                                name,
                                TextFeatures.smallnormal,
                                fancyIcon: diet.isPresetDietWithSubDiets() ?
                                  (diet as PresetDietWithSubdiets).subDiets[index].iconWidget :
                                  (diet as CustomDiet).dietFeatures![index].iconWidget,
                                animationValue: animationValue 
                              );
                            }
                          );
                        },
                      ),
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
                              text: diet.isProhibitive
                                  ? 'Prohibited'
                                  : 'Allowed',
                              style: googleFonts(17, color: diet.isProhibitive
                                    ? Colors.red
                                    : Colors.green,),
                            ),
                            TextSpan(
                              text: ' items: ',
                              style: googleFonts(17)
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
                            TextSpan(
                              text: 'Possibly ',
                              style: googleFonts(
                                // fontWeight: FontWeight.bold,
                                17,
                                color: Colors.orange,
                              ),
                            ),
                            TextSpan(
                              text: diet.isProhibitive
                                  ? 'prohibited'
                                  : 'allowed',
                              style: googleFonts(
                                // fontWeight: FontWeight.bold,
                                17,
                                color: diet.isProhibitive
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            TextSpan(
                              text: ' items: ',
                              style: googleFonts(17),
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
                );
              }),
            ),
            InfoSlider(
              isInfoShown: _isInfoShown,
              title: '${(diet.name=='') ? '[unnamed]' : diet.name} Diet Info',
              icon: (diet is PresetDiet) ? Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    globalShadow(false, color: Colors.black)
                  ],
                  shape: BoxShape.circle
                ),
                child: diet.iconWidget
              ) : null,
              info: diet.dietInfo == '' ?
              '[no diet info has been entered yet]' : diet.dietInfo,
              onClose: () => setState(() {
                _isInfoShown = false;
              }),
            ),
          ],
        ),
      ),
    );
  }
}