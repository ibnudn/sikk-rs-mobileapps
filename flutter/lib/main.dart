import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sikk_rs/View/MainPage.dart';
import 'package:sikk_rs/View/Templates/BaseAppBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: HexColor("#45B6FE"),
            secondary: HexColor("#ADD8E6"),
          ),
          iconTheme: IconThemeData(color: Colors.white)),
      home: Scaffold(
        appBar: BaseAppBar(),
        body: MainPage(),
      ),
    );
  }
}
