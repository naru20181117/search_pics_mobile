import 'package:flutter/material.dart';

class TranstionSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: new AppBar(
        title: const Text(
          'Flutter Second Screen',
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
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
              'Next Third',
              style: TextStyle(fontSize: 30.0),
            ),
            color: Colors.orange,
            onPressed: () {
              Navigator.of(context).pushNamed('/third');
            },
          ),
        ),
      ),
    );
  }
}
