import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_class.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_pages/diet_detail_page/diet_detail_page_helper_functions.dart';


class DietDetailPage extends StatefulWidget {
  final int dietIndex;

  const DietDetailPage({
    required this.dietIndex,
  });

  @override
  State<DietDetailPage> createState() => _DietDetailPageState();
}

class _DietDetailPageState extends State<DietDetailPage> {
  bool _isInfoShown = false;

  @override
  Widget build(final BuildContext context) {
  final String dietName = (DietState.getDietList()[widget.dietIndex].name=='') ? '[unnamed]' : DietState.getDietList()[widget.dietIndex].name;
    return SafeArea(
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              _isInfoShown ? Colors.black.withOpacity(0.5) : Colors.transparent, // Dark color with opacity
              BlendMode.darken,
            ),
            child: Consumer<DietState>(builder: (final context, final dietState, final _) {
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
                    ),
                    DietState.getDietList()[widget.dietIndex].isPresetDietWithSubDiets() ? 
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
                            itemCount: (DietState.getDietList()[widget.dietIndex] as PresetDietWithSubdiets).subDiets.length,
                            itemBuilder: (final context, final index) {
                              final String name = (DietState.getDietList()[widget.dietIndex] as PresetDietWithSubdiets).subDiets[index].name;
                              return libraryCard(
                                name,
                                TextFeatures.smallnormal,
                                fancyIcon: 
                                  (DietState.getDietList()[widget.dietIndex] as PresetDietWithSubdiets).subDiets[index].iconWidget
                              );
                            },
                          ),
                        // ),
                    //   ],
                    ) : Container(),
                    DietState.getDietList()[widget.dietIndex].isPresetDietWithSubDiets() ? 
                      const Padding(padding: EdgeInsets.only(top: 2)) : 
                      Container(),
                    DietState.getDietList()[widget.dietIndex].isPresetDietWithSubDiets() ? 
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
                              text: DietState.getDietList()[widget.dietIndex].name.toLowerCase(),
                              style: kStyle4(ColorReturner().primary),
                            ),
                            TextSpan(
                              text: ' diet, the following items are ',
                              style: kStyle4(Colors.black)
                            ),
                            TextSpan(
                              text: DietState.getDietList()[widget.dietIndex].isProhibitive
                                  ? 'prohibited'
                                  : 'allowed',
                              style: kStyle4(DietState.getDietList()[widget.dietIndex].isProhibitive
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
                    itemsDisplayWidget(DietState.getDietList()[widget.dietIndex].primaryItems),
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
                              text: DietState.getDietList()[widget.dietIndex].isProhibitive
                                  ? 'prohibited'
                                  : 'allowed',
                              style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: DietState.getDietList()[widget.dietIndex].isProhibitive
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
                    itemsDisplayWidget(DietState.getDietList()[widget.dietIndex].secondaryItems),
                    !(DietState.getDietList()[widget.dietIndex].isCustom())
                    ? Container()
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: editDietButton(context, widget.dietIndex, _isInfoShown)
                    ),
                  ],
                  )
                ),
              );
            }),
          ),
          InfoSlider(
            isInfoShown: _isInfoShown,
            title: '$dietName Diet Info',
            info: DietState.getDietList()[widget.dietIndex].dietInfo == '' ?
            '[no diet info has been entered yet]' : DietState.getDietList()[widget.dietIndex].dietInfo,
            onClose: () => setState(() {
              _isInfoShown = false;
            }),
          ),
        ],
      ),
    );
  }
}