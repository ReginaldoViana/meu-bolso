import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IconGenerator.generate();
}

class IconGenerator {
  static Future<void> generate() async {
    // Criar um recorder para desenhar
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(1024, 1024);

    // Desenhar fundo branco
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );

    // Desenhar o ícone
    final iconPainter = WalletIconPainter();
    iconPainter.paint(canvas, size);

    // Converter para imagem
    final picture = recorder.endRecording();
    final image =
        await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    // Salvar imagem
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/icon.png');
    await file.writeAsBytes(bytes);

    // Gerar ícone adaptativo para Android
    final foregroundFile = File('${directory.path}/icon_foreground.png');
    await foregroundFile.writeAsBytes(bytes);

    final backgroundFile = File('${directory.path}/icon_background.png');
    final backgroundImage = await _createSolidColorImage(
      1024,
      1024,
      Colors.white,
    );
    await backgroundFile.writeAsBytes(backgroundImage);

    print('Ícones gerados com sucesso em:');
    print('  - ${file.path}');
    print('  - ${foregroundFile.path}');
    print('  - ${backgroundFile.path}');
  }

  static Future<Uint8List> _createSolidColorImage(
    int width,
    int height,
    Color color,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = color;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}

class WalletIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEF5350) // Material Red 400
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
