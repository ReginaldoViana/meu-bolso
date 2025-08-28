import 'package:flutter/material.dart';

final iconeCarteira = CustomPaint(
  painter: CarteiraIconePainter(),
  size: const Size(200, 200),
);

class CarteiraIconePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final path = Path();

    // Desenha o fundo arredondado (wallet)
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromPoints(Offset(size.width * 0.1, size.height * 0.2),
          Offset(size.width * 0.9, size.height * 0.8)),
      Radius.circular(size.width * 0.1),
    );
    canvas.drawRRect(rRect, paint);

    // Desenha as notas de dinheiro saindo da carteira
    final notesPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02;

    // Primeira nota
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.3),
      notesPaint,
    );

    // Segunda nota
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.4),
      notesPaint,
    );

    // Símbolo do dólar
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width * 0.4, size.height * 0.45),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
