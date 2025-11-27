import 'package:flutter/material.dart';
import 'screens/orange_money_home.dart';

void main() {
  runApp(const OrangeMoneyDemo());
}

class OrangeMoneyDemo extends StatelessWidget {
  const OrangeMoneyDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orange Money UI Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        fontFamily: 'Roboto',
      ),
      home: const OrangeMoneyHome(),
    );
  }
}
