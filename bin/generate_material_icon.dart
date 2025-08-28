import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Configurar o Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Criar o widget do ícone
  final icon = Container(
    width: 1024,
    height: 1024,
    color: const Color(0xFF6750A4),
    child: const Center(
      child: Icon(
        Icons.account_balance_wallet_outlined,
        size: 512,
        color: Colors.white,
      ),
    ),
  );

  // Criar o diretório assets/icon se não existir
  final directory = Directory('assets/icon');
  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  // Salvar como PNG
  final iconFile = File('assets/icon/app_icon.png');
  await iconFile.writeAsBytes(await icon.toString().codeUnits);

  // Criar versão foreground (ícone sem fundo)
  final foregroundIcon = Container(
    width: 1024,
    height: 1024,
    child: const Center(
      child: Icon(
        Icons.account_balance_wallet_outlined,
        size: 512,
        color: Colors.white,
      ),
    ),
  );

  final foregroundFile = File('assets/icon/app_icon_foreground.png');
  await foregroundFile.writeAsBytes(await foregroundIcon.toString().codeUnits);

  print('Ícones gerados com sucesso!');
  exit(0);
}
