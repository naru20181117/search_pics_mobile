import 'package:flutter/material.dart';

import 'transtion_second.dart';
import 'transtion_third.dart';
import 'transtion_top.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => new TranstionTop(),
          '/second': (context) => new TranstionSecond(),
          '/third': (context) => new TranstionThird(),
        });
  }
}
