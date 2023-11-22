import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:palette_generator/palette_generator.dart';

///For creating an image theme to match the primary image color
class ImageTheme extends StatelessWidget {
  ///The
  const ImageTheme({super.key, required this.path, required this.child});

  ///the asset image string path
  final String path;

  ///The widget child
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
        future: GetImageTheme.colorSchemeFromImage(theme.colorScheme, path),
        builder: (context, snapShot) {
          final scheme = snapShot.data ?? theme.colorScheme;
          return Theme(data: theme.copyWith(colorScheme: scheme), child: child);
        });
  }
}

class GetImageTheme {
  static Future<Color?> getDominantColor(String path) async {
    try {
      final ImageProvider imageProvider = AssetImage(path, package: 'app_ui');
      final palette = await PaletteGenerator.fromImageProvider(imageProvider);
      return palette.dominantColor?.color;
    } catch (e) {
      debugPrint('error converting image to pixel: $e');
      return null;
    }
  }

  static Future<ColorScheme> colorSchemeFromImage(
    ColorScheme base,
    String path,
  ) async {
    final color = await getDominantColor(path);
    if (color == null) return base;
    final to = base.primary.value;
    final from = color.value;
    final blend = Color(Blend.harmonize(to, from));
    final scheme =
        ColorScheme.fromSeed(seedColor: blend, brightness: base.brightness);
    return scheme;
  }
}
