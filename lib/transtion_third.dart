import 'package:flutter/material.dart';

class TranstionThird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.green[50],
      appBar: new AppBar(
        title: const Text(
          'Flutter Third Screen',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: new Center(
        child: new SizedBox(
          width: 200.0,
          height: 80.0,
          child: new RaisedButton(
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0)),
            child: Text(
              'Return Top',
              style: TextStyle(fontSize: 30.0),
            ),
            color: Colors.green,
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/top'));
            },
          ),
        ),
      ),
    );
  }
}
