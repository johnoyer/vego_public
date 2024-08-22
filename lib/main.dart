import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:vego_flutter_project/barcode_scanner_page/barcode_scanner.dart';
import 'package:vego_flutter_project/manual_entry/manual_entry_page.dart';
import 'package:vego_flutter_project/ingredient_recognition/ingredient_recognition_page.dart';
import 'package:vego_flutter_project/diet_classes/diet_state.dart';
import 'package:vego_flutter_project/diet_pages/diet_manager/diet_manager_page.dart';
import 'package:vego_flutter_project/settings/settings_page.dart';
import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';

void main() async {
  // BindingBase.debugZoneErrorsAreFatal = true;
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final dietState = DietState(); 
    await DietState.initialize();
    await dotenv.load();
    runApp(
      MyApp(dietState: dietState),
    );
  } catch (e) {
    print('Exception: $e');
  }
}

class MyApp extends StatelessWidget {
  final DietState dietState;

  const MyApp({super.key, required this.dietState});

  @override
  Widget build(final BuildContext context) {
    return ChangeNotifierProvider.value(
      value: dietState,
      child: MaterialApp(
        title: 'Vego',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        ),
        home: const HomePage(),
      ) //TODO: determine if cupertinoapp needed
    );
  }
}

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _getPage(final int index) {
    switch (index) {
      case 0:
        return DietPage();
      case 1:
        return const BarcodeScanner();
      case 2: 
        return const ManualEntry();
      case 3:
        return const IngredientRecognition();
      case 4:
        return SettingsPage();
      default:
        throw UnimplementedError('no widget for ${DietState().getSelectedIndex()}');
    }
  }

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Consumer<DietState>(builder: (final context, final dietState, final child) {
        return Scaffold(
          body: _getPage(DietState().getSelectedIndex()),
          backgroundColor: ColorReturner().backGroundColor,
          bottomNavigationBar: const CustomBottomNavigationBar()
        );
      }),
    );
  }

  
}

class ColorTestPage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Test'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildColorTile(theme.primary, 'Primary'),
          _buildColorTile(theme.primaryContainer, 'Primary Container'),
          _buildColorTile(theme.primaryFixed, 'Primary Fixed'),
          _buildColorTile(theme.primaryFixedDim, 'Primary Fixed Dim'),
          _buildColorTile(theme.secondary, 'Secondary'),
          _buildColorTile(theme.secondaryContainer, 'Secondary Container'),
          _buildColorTile(theme.secondaryFixed, 'Secondary Fixed'),
          _buildColorTile(theme.secondaryFixedDim, 'Secondary Fixed Dim'),
          _buildColorTile(theme.surface, 'Surface'),
          _buildColorTile(theme.error, 'Error'),
          _buildColorTile(theme.onPrimary, 'On Primary'),
          _buildColorTile(theme.onSecondary, 'On Secondary'),
          _buildColorTile(theme.onSurface, 'On Surface'),
          _buildColorTile(theme.onError, 'On Error'),
        ],
      ),
    );
  }

  Widget _buildColorTile(final Color color, final String name) {
    return ListTile(
      title: Text(name),
      tileColor: color,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      subtitle: Text(color.toString()),
      dense: true,
    );
  }
}

