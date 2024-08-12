
// class ColorTestPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Color Test'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildColorTile(theme.primary, 'Primary'),
//           _buildColorTile(theme.primaryContainer, 'Primary Container'),
//           _buildColorTile(theme.primaryFixed, 'Primary Fixed'),
//           _buildColorTile(theme.primaryFixedDim, 'Primary Fixed Dim'),
//           _buildColorTile(theme.secondary, 'Secondary'),
//           _buildColorTile(theme.secondaryContainer, 'Secondary Container'),
//           _buildColorTile(theme.secondaryFixed, 'Secondary Fixed'),
//           _buildColorTile(theme.secondaryFixedDim, 'Secondary Fixed Dim'),
//           _buildColorTile(theme.surface, 'Surface'),
//           _buildColorTile(theme.error, 'Error'),
//           _buildColorTile(theme.onPrimary, 'On Primary'),
//           _buildColorTile(theme.onSecondary, 'On Secondary'),
//           _buildColorTile(theme.onSurface, 'On Surface'),
//           _buildColorTile(theme.onError, 'On Error'),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorTile(Color color, String name) {
//     return ListTile(
//       title: Text(name),
//       tileColor: color,
//       contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       subtitle: Text(color.toString()),
//       dense: true,
//     );
//   }
// }

