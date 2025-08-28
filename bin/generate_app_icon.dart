import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui' as ui;

void main() async {
  // Configurar o Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Criar um recorder para desenhar
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  const size = Size(1024, 1024);

  // Desenhar o ícone
  final paint = Paint()
    ..color = const Color(0xFF6750A4) // Cor roxa do tema
    ..style = PaintingStyle.fill;

  // Desenhar fundo
  canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

  // Configurar o paint para a carteira (branco)
  paint.color = Colors.white;

  // Desenhar a carteira (um retângulo arredondado)
  final walletRect = Rect.fromLTWH(
    size.width * 0.2, // 20% da margem esquerda
    size.height * 0.25, // 25% do topo
    size.width * 0.6, // 60% da largura
    size.height * 0.5, // 50% da altura
  );

  canvas.drawRRect(
    RRect.fromRectAndRadius(walletRect, Radius.circular(size.width * 0.1)),
    paint,
  );

  // Desenhar linhas representando dinheiro (em roxo)
  paint.color = const Color(0xFF6750A4);
  paint.strokeWidth = size.width * 0.02;
  paint.style = PaintingStyle.stroke;

  // Primeira linha
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.35,
        size.width * 0.4,
        size.height * 0.08,
      ),
      Radius.circular(size.width * 0.01),
    ),
    paint,
  );

  // Segunda linha
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.45,
        size.width * 0.4,
        size.height * 0.08,
      ),
      Radius.circular(size.width * 0.01),
    ),
    paint,
  );

  // Converter para imagem
  final picture = recorder.endRecording();
  final image = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  if (byteData == null) {
    print('Erro ao gerar o ícone: byteData é null');
    return;
  }

  final bytes = byteData.buffer.asUint8List();

  // Salvar o ícone
  final androidIconPath =
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png';
  final iosIconPath =
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png';

  // Garantir que os diretórios existem
  await Directory(androidIconPath).parent.create(recursive: true);
  await Directory(iosIconPath).parent.create(recursive: true);

  // Salvar os arquivos
  await File(androidIconPath).writeAsBytes(bytes);
  await File(iosIconPath).writeAsBytes(bytes);

  print('Ícones gerados com sucesso em:');
  print('- $androidIconPath');
  print('- $iosIconPath');
}
