import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vego_flutter_project/barcode_scanner_page/scanner_button_widgets.dart';
import 'package:vego_flutter_project/barcode_scanner_page/scanner_error_widget.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';

Future<Map<String, dynamic>?>  fetchBarcodeData(final String barcodeValue) async {
  final apiKey = dotenv.env['barcodeApiKey'];
  final url = 'https://api.barcodelookup.com/v3/products?barcode=$barcodeValue&formatted=y&key=$apiKey';

  try {
    final response = await http.get(
      Uri.parse(url)
    );

    if (response.statusCode == 200) {
      // Successful API call
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData;
    } else {
      // Handle errors
      print('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Handle exceptions
    print('Exception during API call: $e');
    return null;
  }
}

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() =>
      _BarcodeScannerState();
}

class _BarcodeScannerState
    extends State<BarcodeScanner> {
  final MobileScannerController controller = MobileScannerController(
    torchEnabled: true,
    returnImage: true,
  );

  bool _barcodeScanned = false;
  Map<String, dynamic>? _ingredientInfo;
  List<String> checkedDiets = [];

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }

  Future<void> onBarcodeScanned(final String barcode) async {
    final ingredientInfo = await loadDataAndCheckIngredients(barcode);
    setState(() {
      _barcodeScanned = true;
      _ingredientInfo = ingredientInfo;
    });
  }

  Future<Map<String, dynamic>?> loadDataAndCheckIngredients(final String barcode) async {
    // await 
    DietState.loadDietData();

    // final barcodeData = await fetchBarcodeData(barcode);
    // if (barcodeData == null) throw Exception('barcode data is null');

    // final product = barcodeData['products'][0];
    // final ingredients = product['ingredients'] ?? 'No ingredients available';

    const itemName = 'Simple Mills, Almond Flour Baking Mix, Banana Muffin & Bread, 9 Oz (255 G)';
    const ingredients = 'Almonds, Banana, Organic Coconut Sugar, Arrowroot Powder, gluconolactone, Organic Coconut Flour, Chicken, beef, milk, Baking Soda, Sea Salt';

    List<String> ingredientsListFormat = ingredients.split(', ');
    ingredientsListFormat = ingredientsListFormat.map((final string) => string.toLowerCase().trim()).toList();

    // final nonConformingIngredients = dietChecker.getNonConformingIngredients(ingredientsListFormat);
    // final canBeConformingIngredients = dietChecker.getPossiblyNonConformingIngredients(ingredientsListFormat);

    return {
      // 'itemName': product['title'],
      'itemName': itemName,
      'ingredients': ingredients,
      // 'nonConformingIngredients': nonConformingIngredients,
      // 'canBeConformingIngredients': canBeConformingIngredients
    };
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: upperHeight,
            child: _barcodeScanned && _ingredientInfo != null ? buildDietInfo(context) : _buildCameraView(),
          ),
          globalDivider(),
          Expanded(
            child: _barcodeScanned && _ingredientInfo != null ? buildIngredientInfo(_ingredientInfo, context) : _buildTemporary(),
          ),
        ],
      ),
    );
  }

  Widget _buildTemporary() {
    return StreamBuilder<BarcodeCapture>(
      stream: controller.barcodes,
      builder: (final context, final snapshot) {
        if(snapshot.hasData) {
          final barcodes = snapshot.data!.barcodes;
          if (barcodes.isNotEmpty) { // Check if barcodes is not empty
            final barcode = barcodes.first.displayValue;
            if (barcode != null) {
              onBarcodeScanned(barcode);
            }
          }
        }
        return Center(
          child: libraryCard('Scan a Barcode', TextFeatures.large),
        );
      },
    );
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: ColoredBox(
            color: const Color.fromARGB(0, 211, 210, 210),
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  errorBuilder: (final context, final error, final child) {
                    return ScannerErrorWidget(error: error);
                  },
                  fit: BoxFit.contain,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    height: 100,
                    // color: Colors.black.withOpacity(0.4),
                    color: Colors.black.withOpacity(0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ToggleFlashlightButton(controller: controller),
                        StartStopMobileScannerButton(controller: controller),
                        const Expanded(
                          child: Center(
                            // child: ScannedBarcodeLabel(
                            //   barcodes: controller.barcodes,
                            // ),
                          ),
                        ),
                        SwitchCameraButton(controller: controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Only used in barcode scanner
Widget buildIngredientInfo(final Map<String, dynamic>? ingredientInfo, final BuildContext context) {
  
  final data = ingredientInfo!;
  print(data['itemName']);
  final itemName = data['itemName'];
  final ingredients = data['ingredients'];

  return Column(
    children: [
      itemName == null ? libraryCard('Product Title:', TextFeatures.normal) : Container(),
      itemName == null ? Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),  
        child: Text(
          itemName,
        ),
      ) : Container(),
      libraryCard('Ingredients:', TextFeatures.normal),
      ingredients ? Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Text(
          ingredients,
        ),
      ) : Container(),
    ],
  );
}