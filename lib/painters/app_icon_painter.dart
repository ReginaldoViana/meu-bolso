import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar fundo roxo
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF6750A4),
    );

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Desenhar a carteira (um pouco maior e mais centralizada)
    final walletPath = Path();
    final rect = Rect.fromLTWH(
      size.width * 0.2, // 20% da margem esquerda
      size.height * 0.25, // 25% do topo
      size.width * 0.6, // 60% da largura
      size.height * 0.5, // 50% da altura
    );
    final radius = size.width * 0.1;
    walletPath.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    canvas.drawPath(walletPath, paint);

    // Desenhar notas (linhas simplificadas em branco)
    final notePaint = Paint()
      ..color = const Color(0xFF6750A4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    // Primeira nota
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.35,
          size.width * 0.4,
          size.height * 0.1,
        ),
        Radius.circular(size.width * 0.02),
      ),
      notePaint,
    );

    // Segunda nota
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.25,
          size.height * 0.45,
          size.width * 0.4,
          size.height * 0.1,
        ),
        Radius.circular(size.width * 0.02),
      ),
      notePaint,
    );

    // Símbolo R$
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'R\$',
        style: TextStyle(
          color: Color(0xFF6750A4),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) * 0.5,
        size.height * 0.4,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
