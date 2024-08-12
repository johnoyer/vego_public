import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vego_flutter_project/barcode_scanner_page/scanner_button_widgets.dart';
import 'package:vego_flutter_project/barcode_scanner_page/scanner_error_widget.dart';

class BarcodeScannerWithController extends StatefulWidget {
  const BarcodeScannerWithController({super.key});

  @override
  State<BarcodeScannerWithController> createState() =>
      _BarcodeScannerWithControllerState();
}

class _BarcodeScannerWithControllerState
    extends State<BarcodeScannerWithController> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,
    torchEnabled: true,
    useNewCameraSelector: true,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  Widget _buildBarcode(final Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(final BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);

    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('With controller')),
      backgroundColor: Colors.black,
      body: Stack(
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
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  StartStopMobileScannerButton(controller: controller),
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                  SwitchCameraButton(controller: controller),
                  AnalyzeImageFromGalleryButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}
