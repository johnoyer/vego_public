import 'package:vego_flutter_project/library/barrel.dart';
import 'package:vego_flutter_project/global_widgets/barrel.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  const CustomBottomNavigationBar();

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final Color selectedItemColor =  const Color.fromARGB(255, 70, 20, 16);

  int _selectedIndex = 0;

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: 50,
      color: ColorReturner().bottombarColor,
      child: Row(
        children: [
          _buildNavItem(0),
          _buildNavItem(1),
          _buildNavItem(2),
          _buildNavItem(3),
          _buildNavItem(4),
        ],
      )
    );
  }

  Widget _buildNavItem(final int index) {
    return _selectedIndex==index ? 
      bottomNavigationItems[index].activeIcon : 
      bottomNavigationItems[index].icon;
  }

  List<BottomNavigationBarItem> get bottomNavigationItems {
    return <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        // label: isAndroid() ? 'Manage Diets' : null,
        label: 'Manage Diets',
        icon: Tooltip(
          message: 'Manage Diets',
          child: Icon(Icons.local_dining_rounded),
        ),
        activeIcon: Tooltip(
          message: 'Manage Diets',
          child: Icon(Icons.local_dining_sharp),
        ),
      ),
      const BottomNavigationBarItem(
        // label: isAndroid() ? 'Scan Barcode' : null,
        label: 'Scan Barcode',
        icon: Tooltip(
          message: 'Scan Barcode',
          child: Icon(Icons.qr_code),
        ),
        activeIcon: Tooltip(
          message: 'Scan Barcode',
          child: Icon(Icons.qr_code_scanner),
        ),
      ),
      const BottomNavigationBarItem(
        // label: isAndroid() ? 'Manual Entry' : null,
        label: 'Manual Entry',
        icon: Tooltip(
          message: 'Manual Entry',
          child: Icon(Icons.edit),
        ),
        activeIcon: Tooltip(
          message: 'Manual Entry',
          child: Icon(Icons.edit_note),
        ),
      ),
      const BottomNavigationBarItem(
        // label: isAndroid() ? 'Scan Ingredients' : null,
        label: 'Scan Ingredients',
        icon: Tooltip(
          message: 'Scan Ingredients',
          child: Icon(Icons.document_scanner_outlined),
        ),
        activeIcon: Tooltip(
          message: 'Scan Ingredients',
          child: Icon(Icons.document_scanner),
        ),
      ),
      const BottomNavigationBarItem(
        // label: isAndroid() ? 'Settings' : null,
        label: 'Settings',
        icon: Tooltip(
          message: 'Settings',
          child: Icon(Icons.settings_applications_outlined)
        ),
        activeIcon: Tooltip(
          message: 'Settings',
          child: Icon(Icons.settings_applications),
        ),
      ),
    ];
  }
}
