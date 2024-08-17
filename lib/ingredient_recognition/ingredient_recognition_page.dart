import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:async/async.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vego_flutter_project/library/library.dart';
import 'package:vego_flutter_project/global_widgets/global_widgets.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';

import 'package:vego_flutter_project/ingredient_recognition/ingredient_processing_functions.dart';
import 'package:vego_flutter_project/ingredient_recognition/line_animations.dart';
import 'package:vego_flutter_project/ingredient_recognition/camera_preview_overlay.dart';
import 'package:vego_flutter_project/ingredient_recognition/helper_functions.dart';

class IngredientRecognition extends StatefulWidget {

  const IngredientRecognition({super.key});

  @override
  State<IngredientRecognition> createState() =>
      _IngredientRecognition();
}

class _IngredientRecognition extends State<IngredientRecognition> with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late AnimationController _animationController;
  bool _ingredientListObtained = false;
  bool _awaitingResult = false;
  bool _secondaryView = false;
  bool _isInfoShown = false;
  Uint8List? _capturedImage;
  double? _aspectRatio;
  double? _originalHeight;
  double? _originalWidth;
  final List<LineData> _lines = [];
  final List<TextSpan> _spans = [];
  late CameraDescription camera;
  bool _initializationDone = false;
  final List<CancelableOperation> _operations = [];

  @override
  void initState() {
    super.initState();
    // _operations used so that delayed statements can be cancelled without causing error
    _operations.add(
      CancelableOperation.fromFuture(
        _initializeCamera()
      )
    );
    _operations.add(
      CancelableOperation.fromFuture(
        _initialize()
      )
    );
  }

  Future<void> _initialize() async {
    await DietState.loadDietData();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: DietState.slowIngredientAnimations ? 10 : 1),
    );
  }

  @override
  void dispose() {
    // Cancel all timing operations
    for (var operation in _operations) {
      operation.cancel();
    }
    _operations.clear();
    if(_initializationDone) {
      _cameraController.dispose(); // only dispose if _cameraController has been initialized
    }
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startAnimation () async {
    await _animationController.forward();
  }

  Future<void> _initializeCamera() async {
    final List<CameraDescription> cameras = await availableCameras();
    camera = cameras.first;
    _cameraController = CameraController(
      enableAudio: false,
      camera,
      ResolutionPreset.max, // Set the camera to max resolution
    );
    await _cameraController.initialize();
    setState(() {
      _initializationDone = true;
    });
  }

  @override
  Widget build(final BuildContext context) {
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
                        width: 100,
                      ),
                      const Spacer(),
                      _ingredientListObtained ? buildDietInfo(context) : _buildPictureTakeButton(),
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: isAndroid() ? InkWell(
                          onTap: () {
                            _initializationDone ? setState(() {
                              _isInfoShown = true;
                            }) : null;
                          },
                          child: questionMarkIconCard(),
                        ) : CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _initializationDone ? setState(() {
                              _isInfoShown = true;
                            }) : null;
                          },
                          child: questionMarkIconCard(),
                        ),
                      ),  
                    ],
                  ),
                ),
              ],
            ),
          ),
          InfoSlider(
            isInfoShown: _isInfoShown,
            title: 'Ingredient Recognition Info',
            info: info,
            onClose: () => setState(() {
              _isInfoShown = false;
            }),
          ),
        ],
      ),
    ); 
  }

  Future<void> _captureImage() async {
    setState(() {
      _awaitingResult = true;
      _cameraController.pausePreview();
    });
    // try {
    final XFile image = await _cameraController.takePicture();

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
    // } catch (e) {
    //   print('Error capturing image: $e');
    // }
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
      await ingredientProcessing(response.body);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> ingredientProcessing(final String responseBody) async {
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
      DietState().setStatus(Status.none);
      final StatusStyledTextReturn statusStyledTextReturn = addLinesAndDetermineStatus(
        shortenedTextListFormat, 
        wordList, 
        xInitialList, 
        yInitialList, 
        xFinalList, 
        yFinalList
      );
      final Status localStatus = statusStyledTextReturn.status;
      _lines.addAll(statusStyledTextReturn.lines!);
      _spans.add(statusStyledTextReturn.styledText);

      // Sixth/final step: 
      setState(() {
        _awaitingResult = false;
        DietState().setStatus(localStatus);
        DietState().setIngredients(shortenedTextListFormat);
        _ingredientListObtained = true;
      });
      if(DietState.spellCheck) {
        await spellCheck();
      }
      _operations.add(
        CancelableOperation.fromFuture(
          _startAnimation()
        )
      );

    } else {
      setState(() {
        _awaitingResult = false;
        _capturedImage = null;
      });
      if (!mounted) return; // To ensure that context is not used across async gaps
      _cameraController.pausePreview();
      _cameraController.resumePreview();
      showAlert(context, 3, 'Ingredient List Not Found', secondaryText: 'Try scanning the list again');
    }
  }

  Widget _buildPictureTakeButton() {
    return 
    PlatformWidget(
      ios: (final context) => _awaitingResult ? const Center(child: CupertinoActivityIndicator()) :
        CupertinoButton(
          onPressed: () {
            _isInfoShown||!_initializationDone ? null : _operations.add(
              CancelableOperation.fromFuture(
                _captureImage() // do nothing if the page info is shown
              )
            );
          },
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(25.0),
          child: cameraIconCard()
        ),
      android: (final context) => _awaitingResult ? const Center(child: CircularProgressIndicator()) :
        InkWell(
          onTap: () {
            _isInfoShown||!_initializationDone ? null : _operations.add(
              CancelableOperation.fromFuture(
                _captureImage() // do nothing if the page info is shown
              )
            );
          },
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
    final TextSpan styledText = TextSpan(children: _spans);

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
                isAndroid() ? InkWell(
                  onTap: () {
                    _isInfoShown||!_initializationDone ? null : setState(() { // do nothing if the page info is shown
                      _secondaryView = !_secondaryView;
                    });
                  },
                  child: swapViewingModeCard()
                ) : CupertinoButton(
                  onPressed: () {
                    _isInfoShown||!_initializationDone ? null : setState(() { // do nothing if the page info is shown
                      _secondaryView = !_secondaryView;
                    });
                  },
                  child: swapViewingModeCard()
                ),
                isAndroid() ? InkWell(
                  onTap: () {
                    _isInfoShown||!_initializationDone ? null : DietState().updateSelectedIndex(2); // do nothing if the page info is shown
                  },
                  child: editIngredientInformationCard()
                ) : CupertinoButton(
                  onPressed: () {
                    _isInfoShown||!_initializationDone ? null : DietState().updateSelectedIndex(2); // do nothing if the page info is shown
                  },
                  child: editIngredientInformationCard()
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildCameraView() {
    return Center(
      child: _initializationDone ? Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(3.1415926535897932384626433), // flip image
        child: Stack(
          children: [
            CameraPreview(_cameraController),
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