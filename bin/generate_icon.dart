import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() async {
  await generateIcon();
}

Future<void> generateIcon() async {
  // Criar uma imagem 1024x1024
  final image = img.Image(width: 1024, height: 1024);

  // Preencher com fundo branco
  img.fillRect(image,
      x1: 0,
      y1: 0,
      x2: image.width - 1,
      y2: image.height - 1,
      color: img.ColorInt32.rgb(255, 255, 255));

  // Desenhar carteira (retângulo roxo)
  final walletColor = img.ColorInt32.rgb(103, 80, 164); // #6750A4
  final walletX = (image.width * 0.15).round();
  final walletY = (image.height * 0.25).round();
  final walletWidth = (image.width * 0.7).round();
  final walletHeight = (image.height * 0.5).round();

  drawRoundedRect(image,
      x: walletX,
      y: walletY,
      width: walletWidth,
      height: walletHeight,
      radius: (image.width * 0.1).round(),
      color: walletColor);

  // Desenhar notas de dinheiro (retângulos brancos)
  final whiteColor = img.ColorInt32.rgb(255, 255, 255);
  final note1X = (image.width * 0.25).round();
  final note1Y = (image.height * 0.2).round();
  final noteWidth = (image.width * 0.5).round();
  final noteHeight = (image.height * 0.1).round();

  drawRoundedRect(image,
      x: note1X,
      y: note1Y,
      width: noteWidth,
      height: noteHeight,
      radius: (image.width * 0.02).round(),
      color: whiteColor);

  final note2X = (image.width * 0.2).round();
  final note2Y = (image.height * 0.15).round();

  drawRoundedRect(image,
      x: note2X,
      y: note2Y,
      width: noteWidth,
      height: noteHeight,
      radius: (image.width * 0.02).round(),
      color: whiteColor);

  // Criar diretórios se não existirem
  final iconDir = Directory('android/app/src/main/res/mipmap-xxxhdpi');
  if (!await iconDir.exists()) {
    await iconDir.create(recursive: true);
  }

  // Salvar a imagem
  final iconBytes = img.encodePng(image);
  final iconFile = File('${iconDir.path}/ic_launcher.png');
  await iconFile.writeAsBytes(iconBytes);

  print('Ícone gerado com sucesso em: ${iconFile.path}');
}

void drawRoundedRect(img.Image image,
    {required int x,
    required int y,
    required int width,
    required int height,
    required int radius,
    required img.ColorInt32 color}) {
  // Desenhar retângulo com cantos arredondados
  for (int i = x; i < x + width; i++) {
    for (int j = y; j < y + height; j++) {
      // Verificar se o pixel está dentro do retângulo arredondado
      if (isInsideRoundedRect(i - x, j - y, width, height, radius)) {
        img.drawPixel(image, i, j, color);
      }
    }
  }
}

bool isInsideRoundedRect(int x, int y, int width, int height, int radius) {
  // Verificar se o ponto está dentro do retângulo com cantos arredondados
  if (x < radius) {
    if (y < radius) {
      return sqrt(pow(x - radius, 2) + pow(y - radius, 2)) <= radius;
    } else if (y > height - radius) {
      return sqrt(pow(x - radius, 2) + pow(y - (height - radius), 2)) <= radius;
    }
  } else if (x > width - radius) {
    if (y < radius) {
      return sqrt(pow(x - (width - radius), 2) + pow(y - radius, 2)) <= radius;
    } else if (y > height - radius) {
      return sqrt(
              pow(x - (width - radius), 2) + pow(y - (height - radius), 2)) <=
          radius;
    }
  }
  return x >= 0 && x < width && y >= 0 && y < height;
}
