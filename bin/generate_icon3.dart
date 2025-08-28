import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  // Cria uma nova imagem com fundo transparente
  final image = img.Image(width: 1024, height: 1024);

  // Preenche com branco
  img.fill(image, color: img.ColorUint8.rgb(255, 255, 255));

  // Desenha um círculo roxo
  img.fillCircle(
    image,
    x: image.width ~/ 2,
    y: image.height ~/ 2,
    radius: (image.width * 0.4).toInt(),
    color: img.ColorUint8.rgb(103, 80, 164), // #6750A4
  );

  // Cria o diretório se não existir
  final iconDir = Directory('assets/icon');
  if (!iconDir.existsSync()) {
    iconDir.createSync(recursive: true);
  }

  // Salva como PNG
  final pngData = img.encodePng(image);
  File('assets/icon/app_icon.png').writeAsBytesSync(pngData);
  File('assets/icon/app_icon_foreground.png').writeAsBytesSync(pngData);

  print('Ícones gerados com sucesso!');
}
