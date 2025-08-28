import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:meu_bolso/painters/wallet_icon_painter.dart';

class IconGeneratorWidget extends StatelessWidget {
  final Function(Uint8List) onIconGenerated;

  const IconGeneratorWidget({
    super.key,
    required this.onIconGenerated,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: 1024,
        height: 1024,
        color: Colors.white,
        child: CustomPaint(
          painter: WalletIconPainter(),
          size: const Size(1024, 1024),
        ),
      ),
    );
  }
}
