import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vego_flutter_project/library.dart';
import 'package:vego_flutter_project/global_widgets.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';

import 'package:vego_flutter_project/ingredient_recognition/ingredient_processing_functions.dart';
import 'package:vego_flutter_project/ingredient_recognition/line_animations.dart';
import 'package:vego_flutter_project/ingredient_recognition/camera_preview_overlay.dart';

// import 'package:flutter/cupertino.dart';

class IngredientRecognition extends StatefulWidget {

  const IngredientRecognition({super.key});

  @override
  State<IngredientRecognition> createState() =>
      _IngredientRecognition();
}

class _IngredientRecognition extends State<IngredientRecognition> with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late AnimationController _animationController;
  bool _ingredientListObtained = false;
  bool _awaitingResult = false;
  bool _secondaryView = false;
  Uint8List? _capturedImage;
  double? _aspectRatio;
  double? _originalHeight;
  double? _originalWidth;
  final List<LineData> _lines = [];
  late CameraDescription camera;
  bool _initializationDone = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    initialize();
  }

  Future<void> initialize() async {
    await DietState.loadDietData();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: DietState.slowIngredientAnimations ? 10 : 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation () async {
    await _animationController.forward();
  }

  Future<void> _initializeCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    camera = cameras.first;
    _controller = CameraController(
      enableAudio: false,
      camera,
      ResolutionPreset.max, // Set the camera to max resolution
    );
    await _controller.initialize();
    setState(() {
      _initializationDone = true;
    });
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: upperHeight,
            child: _ingredientListObtained 
              ? _buildIngredientImage()
              :  _buildCameraView()
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 70,
                ),
                const Spacer(),
                _ingredientListObtained ? buildDietInfo(context) : _buildPictureTakeButton(),
                const Spacer(),
                Column(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: informationButton(context,
                        'Ingredient List Scanner Info',
                        'This ingredient list scanner lets you take a picture of an ingredient list to determine '
                        'whether it is compatible with your diet. Take a picture by tapping the camera icon, '
                        'ensuring that all ingredients are fully within the frame.\n\nOnce the list has been '
                        'successfully scanned, you may swap between viewing the image taken and visualizing the '
                        'list of ingredients in text format. Make sure that the ingredients have been correctly '
                        'scanned and that no ingredients are missing or have been incorrectly read.\n\nYou may '
                        'edit the scanned list of ingredients in case there are any errors, or if you want to '
                        'remove some ingredients or add some of your own!'
                      ),
                    ),
                  ],
                ),  
              ],
            ),
          ),
        ],
      ),
    ); 
  }

  Future<void> _captureImage() async {
    setState(() {
      _awaitingResult = true;
    });
    try {
      final XFile image = await _controller.takePicture();
      final bytes = await image.readAsBytes();

      img.Image imageToReverse = img.decodeImage(Uint8List.fromList(bytes))!;
      imageToReverse = img.flipHorizontal(imageToReverse); //flip image
      final reversedBytes = img.encodeJpg(imageToReverse); 
      setState(() {
        _capturedImage = Uint8List.fromList(reversedBytes);
      });

      final base64Image = base64Encode(reversedBytes);
      await _sendToGoogleCloudVision(base64Image);

      _originalWidth = imageToReverse.width.toDouble();
      _originalHeight = imageToReverse.height.toDouble();
      _aspectRatio = _originalWidth!/_originalHeight!;
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  Future<void> _sendToGoogleCloudVision(final String base64Image) async {
    final apiKey = dotenv.env['cloudVisionApiKey'];
    final url = 'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'requests': [
          {
            'image': {
              'content': base64Image,
            },
            'features': [
              {
                'type': 'TEXT_DETECTION',
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      ingredientProcessing(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void ingredientProcessing(final String responseBody) {
    final jsonResponse = json.decode(responseBody);
    if (jsonResponse['responses'] != null && jsonResponse['responses'][0]['textAnnotations'] != null) {
      // textAnnotations contains the full text ('description') as well as every word with information
      final textAnnotations = jsonResponse['responses'][0]['textAnnotations'];
      final fullText = textAnnotations[0]['description'];

      // First step: trim the fullText
      final TrimReturn trimReturn = trim(fullText);

      final String shortenedText = trimReturn.shortenedText;
      final bool trimBeginning = trimReturn.trimBeginning;
      final bool trimEnd = trimReturn.trimEnd;

      // Second step: determine how the ingredient list is separated
      final SeparationStyle separationStyle = determineSeparationStyle(shortenedText);

      // Third step: find the corresponding indices in textAnnotations
      final IndicesReturn indices = findIndices(textAnnotations, trimBeginning, trimEnd);
      final int startingIndexTextAnnotations = indices.startingIndexTextAnnotations;
      final int endingIndexTextAnnotations = indices.endingIndexTextAnnotations;

      // this is the list of words in [startingIndexTextAnnotations, endingIndexTextAnnotations)
      final List<String> wordList = [
        for (int i = startingIndexTextAnnotations; i < endingIndexTextAnnotations; i++)
        textAnnotations[i]['description']
      ];
      // this is the list of initial X coordinates in [startingIndexTextAnnotations, endingIndexTextAnnotations)
      final List<double> xInitialList = [
        for (int i = startingIndexTextAnnotations; i < endingIndexTextAnnotations; i++)
        textAnnotations[i]['boundingPoly']['vertices'][3]['x']
      ];
      // this is the list of initial Y coordinates in [startingIndexTextAnnotations, endingIndexTextAnnotations)
      final List<double> yInitialList = [
        for (int i = startingIndexTextAnnotations; i < endingIndexTextAnnotations; i++)
        textAnnotations[i]['boundingPoly']['vertices'][3]['y']
      ];
      // this is the list of final X coordinates in [startingIndexTextAnnotations, endingIndexTextAnnotations)
      final List<double> xFinalList = [
        for (int i = startingIndexTextAnnotations; i < endingIndexTextAnnotations; i++)
        textAnnotations[i]['boundingPoly']['vertices'][2]['x']
      ];
      // this is the list of final Y coordinates in [startingIndexTextAnnotations, endingIndexTextAnnotations)
      final List<double> yFinalList = [
        for (int i = startingIndexTextAnnotations; i < endingIndexTextAnnotations; i++)
        textAnnotations[i]['boundingPoly']['vertices'][2]['y']
      ];

      // Fourth step: handle ingredient list separation
      final List<String> shortenedTextListFormat = handleSeparation(shortenedText, separationStyle);

      // Fifth step: add lines and determine status
      setState(() {
        DietState().setStatus(Status.none); // setstate? TODO
      });
      final StatusLinesReturn statusLinesReturn = addLinesAndDetermineStatus(
        shortenedTextListFormat, 
        wordList, 
        xInitialList, 
        yInitialList, 
        xFinalList, 
        yFinalList
      );
      final Status localStatus = statusLinesReturn.status;
      _lines.addAll(statusLinesReturn.lines);

      setState(() {
        _awaitingResult = false;
        DietState().setStatus(localStatus);
        DietState().setIngredients(shortenedTextListFormat);
        _ingredientListObtained = true;
        if(DietState.spellCheck) {
          spellCheck(); // TODO: fix async
        }
        _startAnimation();
      });

    } else {
      setState(() {
        _awaitingResult = false;
        _capturedImage = null;
      });
      if (!mounted) return; // To ensure that context is not used across async gaps
      showAlert(context, 3, 'Ingredient List Not Found', secondaryText: 'Try scanning the list again');
    }
  }

  Widget _buildPictureTakeButton() {
    return 
    PlatformWidget(
      ios: (final context) => _awaitingResult ? const Center(child: CupertinoActivityIndicator()) :
        CupertinoButton(
          onPressed: _captureImage,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(25.0),
          child: cameraIconCard()
        ),
      android: (final context) => _awaitingResult ? const Center(child: CircularProgressIndicator()) :
        InkWell(
          onTap: _captureImage,
          borderRadius: BorderRadius.circular(25.0),
          child: libraryCard(
            null,
            TextFeatures.large, // doesn't do anything in this case
            alternate: false,
            icon: Icons.camera_alt_sharp,
            iconSize: 50,
          )
        ),
    );
  }

  Widget _buildIngredientImage() {
    final List<TextSpan> spans = [];
    final List<String> list = DietState().getIngredientInfo()!.persistentIngredientsList!;
    for (int i=0; i<list.length; i++) {
      final String word = list[i];
      final String modifiedWord = removePrefixes(word);
      if (isRedWord(modifiedWord)) {
        spans.add(TextSpan(text: word, style: kStyle4(Colors.red)));
      } else if (isOrangeWord(modifiedWord)) {
        spans.add(TextSpan(text: word, style: kStyle4(Colors.orange)));
      } else {
        spans.add(TextSpan(text: word, style: kStyle4(Colors.black)));
      }
      if(i!=list.length-1) { // Do not add comma and space at the end
        spans.add(TextSpan(text: ', ', style: kStyle4(Colors.black)));
      }
    }
    final TextSpan styledText = TextSpan(children: spans);

    return LayoutBuilder(
      builder: (final context, final constraints) {
        final double newHeight = constraints.maxHeight;
        final double newWidth = _aspectRatio!*newHeight; //TODO: fix so truly minimized
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_secondaryView
            ? Stack(
              children: [
                Image.memory(_capturedImage!, height: constraints.maxHeight),
                CustomPaint(
                  painter: LinePainter(
                    lines: _lines, 
                    originalHeight: _originalHeight!, 
                    originalWidth: _originalWidth!, 
                    newHeight: newHeight, 
                    newWidth: newWidth,
                    controller: _animationController
                  ),
                ),
              ],
            )
            : SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  libraryCard(
                    'Ingredients:',
                    TextFeatures.normal,
                  ),
                  IgnorePointer(
                    child: RichText(
                      text: styledText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _secondaryView = !_secondaryView;
                    });
                  },
                  child: libraryCard(
                    'Swap Viewing Mode',
                    TextFeatures.small,
                    alternate: false,
                    icon: Icons.visibility
                  )
                ),
                InkWell(
                  onTap: () {
                    DietState().updateSelectedIndex(2);
                  },
                  child: libraryCard(
                    'Edit Ingredient Information',
                    TextFeatures.small,
                    alternate: false,
                    icon: Icons.edit,
                  )
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildCameraView() {
    // _capturedImage!=null ? Image.memory(_capturedImage!) : //TODO: debug
    return Center(
      child: _initializationDone ? Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.1415926535897932384626433), // flip image
        child: Stack(
          children: [
            CameraPreview(_controller),
            // Top-left corner indicator
            cornerIndicator(Position.topLeft),
            // Top-right corner indicator
            cornerIndicator(Position.topRight),
            // Bottom-left corner indicator
            cornerIndicator(Position.bottomLeft),
            // Bottom-right corner indicator
            cornerIndicator(Position.bottomRight),
          ],
        ),
      ) : PlatformWidget(
        ios: (final context) => const Center(child: CupertinoActivityIndicator()),
        android: (final context) => const Center(child: CircularProgressIndicator())
      )
    );
  }
}