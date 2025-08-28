import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class IconGenerator {
  static Future<void> generateIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = const Size(1024, 1024);

    // Fundo branco
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.white,
    );

    // Pintar a carteira
    final paint = Paint()
      ..color = const Color(0xFFEF5350) // Material Red 400
      ..style = PaintingStyle.fill;

    // Desenhar a carteira
    final walletRect = Rect.fromLTWH(
      size.width * 0.15,
      size.height * 0.25,
      size.width * 0.7,
      size.height * 0.5,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        walletRect,
        Radius.circular(size.width * 0.1),
      ),
      paint,
    );

    // Desenhar notas de dinheiro
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Primeira nota
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.2,
          size.width * 0.5,
          size.height * 0.1,
        ),
        Radius.circular(size.width * 0.02),
      ),
      whitePaint,
    );

    // Segunda nota
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.15,
          size.width * 0.5,
          size.height * 0.1,
        ),
        Radius.circular(size.width * 0.02),
      ),
      whitePaint,
    );

    // Desenhar símbolo do dinheiro
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'R\$',
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.2,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width * 0.35, size.height * 0.35),
    );

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    // TODO: Save the image using platform-specific code
  }
}
