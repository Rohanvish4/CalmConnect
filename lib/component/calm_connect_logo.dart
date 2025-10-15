import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A reusable widget for displaying the CalmConnect logo
/// 
/// This widget tries to load a custom logo from assets first,
/// and falls back to the default psychology icon if no custom logo is found.
class CalmConnectLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final bool showBackground;
  
  const CalmConnectLogo({
    super.key,
    this.size = 68,
    this.color,
    this.backgroundColor,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final logoColor = color ?? cs.primary;
    final bgColor = backgroundColor ?? cs.primary.withOpacity(.12);

    return FutureBuilder<bool>(
      future: _checkAssetExists('assets/images/logo.png'),
      builder: (context, snapshot) {
        Widget logoChild;
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading placeholder
          logoChild = Icon(
            Icons.psychology_rounded, 
            size: size * 0.6, 
            color: logoColor,
          );
        } else if (snapshot.data == true) {
          // Custom logo exists, use it
          logoChild = Image.asset(
            'assets/images/logo.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          );
        } else {
          // Fallback to default icon
          logoChild = Icon(
            Icons.psychology_rounded, 
            size: size * 0.6, 
            color: logoColor,
          );
        }

        if (showBackground) {
          return Container(
            width: size + 12,
            height: size + 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Center(child: logoChild),
          );
        } else {
          return SizedBox(
            width: size,
            height: size,
            child: logoChild,
          );
        }
      },
    );
  }

  Future<bool> _checkAssetExists(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }
}