import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF6750A4),
        body: Center(
          child: Container(
            width: 512,
            height: 512,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              size: 300,
              color: Color(0xFF6750A4),
            ),
          ),
        ),
      ),
    ),
  );
}
