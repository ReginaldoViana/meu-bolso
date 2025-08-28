import 'package:flutter/material.dart';

class AppResources {
  static const appIcon = BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(20)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 2),
        blurRadius: 4,
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFEF5350), // Material Red 400
        Color(0xFFE53935), // Material Red 500
      ],
    ),
  );

  static const walletIconData = Icons.account_balance_wallet;
  static const walletIconColor = Colors.white;
  static const moneySymbol = 'R\$';
}
