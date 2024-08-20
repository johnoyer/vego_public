import 'package:flutter/material.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/cards.dart';
import 'package:vego_flutter_project/global_widgets/button.dart';

// Shows informatoin about the page

class InfoSlider extends StatelessWidget {
  final bool isInfoShown;
  final String title;
  final String info;
  final VoidCallback onClose;
  final Widget? icon;

  const InfoSlider({
    required this.isInfoShown,
    required this.title,
    required this.info,
    required this.onClose,
    this.icon
  });

  @override
  Widget build(final BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      top: MediaQuery.of(context).size.height/20,
      bottom: MediaQuery.of(context).size.height/20,
      right: isInfoShown ? -100 : -(MediaQuery.of(context).size.width*4/5 + 100), // 100 is so that the corners of the container on the rightmost side do not appear circular
      child: Container(
        width: MediaQuery.of(context).size.width*4/5 + 100,
        decoration: BoxDecoration(
          color: ColorReturner().backGroundColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            width: 3.0
          )
        ),
        child: Padding(
          padding: EdgeInsets.only(
            right: 100+ MediaQuery.of(context).size.width*1/15,
            left: MediaQuery.of(context).size.width*1/15,
            top: 15,
            bottom: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              libraryCard(
                icon==null ? title : 'Info', // if there is an icon provided override the normal title
                TextFeatures.normal,
                fancyIcon: icon
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      info,
                      style: googleFonts(15)
                    )
                  )
                )
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              LibraryButton(
                onTap: onClose,
                childBuilder: (final double animationValue) {
                  return libraryCard(
                    'Got it!',
                    TextFeatures.normal,
                    alternate: false,
                    animationValue: animationValue,
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
