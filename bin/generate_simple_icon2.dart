import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // Cria uma nova imagem
  final image = img.Image(width: 1024, height: 1024, format: img.Format.uint8);

  // Define as cores
  final white = img.ColorRgba8(255, 255, 255, 255);
  final purple = img.ColorRgba8(103, 80, 164, 255); // #6750A4

  // Preenche com branco
  img.fill(image, color: white);

  // Desenha um círculo roxo
  img.fillCircle(image,
      x: image.width ~/ 2,
      y: image.height ~/ 2,
      radius: (image.width * 0.4).toInt(),
      color: purple);

  // Cria o diretório se não existir
  final iconDir = Directory('assets/icon');
  if (!iconDir.existsSync()) {
    iconDir.createSync(recursive: true);
  }

  // Salva os arquivos
  File('assets/icon/app_icon.png').writeAsBytesSync(img.encodePng(image));
  File('assets/icon/app_icon_foreground.png')
      .writeAsBytesSync(img.encodePng(image));

  print('Ícones gerados com sucesso!');
}
