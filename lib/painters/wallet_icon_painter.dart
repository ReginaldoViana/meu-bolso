import 'package:flutter/material.dart';

class WalletIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6750A4) // Nossa cor primária
      ..style = PaintingStyle.fill;

    // Desenhar a carteira
    final walletPath = Path();
    final rect = Rect.fromLTWH(size.width * 0.15, size.height * 0.25,
        size.width * 0.7, size.height * 0.5);
    final radius = size.width * 0.1;
    walletPath.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    canvas.drawPath(walletPath, paint);

    // Desenhar notas de dinheiro
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Primeira nota
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.25, size.height * 0.2,
                size.width * 0.5, size.height * 0.1),
            Radius.circular(size.width * 0.02)),
        whitePaint);

    // Segunda nota
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * 0.2, size.height * 0.15,
                size.width * 0.5, size.height * 0.1),
            Radius.circular(size.width * 0.02)),
        whitePaint);

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
