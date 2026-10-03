import 'package:flutter/material.dart';

// Màu sắc và theme, giống budget/lib/colors.dart của Cashew.

// Bảng màu cho môn học và màu chủ đạo
const List<String> selectableColours = [
  '0xff2e7d32',
  '0xff1565c0',
  '0xffef6c00',
  '0xff6a1b9a',
  '0xffc62828',
  '0xff00838f',
  '0xff4e342e',
  '0xff37474f',
];

Color colorFromString(String? value, {Color fallback = Colors.grey}) {
  if (value == null) return fallback;
  final parsed = int.tryParse(value);
  return parsed == null ? fallback : Color(parsed);
}

ThemeData getLightTheme(Color seed) => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
      useMaterial3: true,
    );

ThemeData getDarkTheme(Color seed) => ThemeData(
      colorScheme:
          ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
      useMaterial3: true,
    );
