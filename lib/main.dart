import 'package:flutter/material.dart';

import 'transtion_top.dart';
// import 'transtion_third.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => new TranstionTop(),
      // '/second': (context) => new TranstionSecond(),
      // '/third': (context) => new TranstionThird(),
    });
  }
}
