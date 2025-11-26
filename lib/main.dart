import 'package:flutter/material.dart';
import 'package:app_ompay_flutter/view/login_page.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 73, 69, 69),
      ),
      home: const LoginPage(),
    ),
  );
}
