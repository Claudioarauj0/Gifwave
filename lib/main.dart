import 'package:flutter/material.dart';
import 'package:giphy/ui/home_page.dart';


void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: ThemeData(hintColor: Colors.white, primaryColor: Colors.white), //arrumar cor da borda
  ));
}
