import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
        theme: new ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: '/',
        // home: new MyHomePage(),
        routes: {
          '/': (context) => new MyHomePage(),
          '/top': (context) => new TranstionTop(),
          '/second': (context) => new TranstionSecond(),
          '/third': (context) => new TranstionThird(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyGetHttpDataState createState() => new _MyGetHttpDataState();
}

class _MyGetHttpDataState extends State<MyHomePage> {
  final ScrollController _homeController = ScrollController();
  List _data;

  Future<String> _loadAVaultAsset() async {
    return await rootBundle.loadString('json/api_local_connpass.json');
  }

  Future<String> _getLocalJSONData() async {
    String jsonString = await _loadAVaultAsset();

    setState(() {
      final jsonData = json.decode(jsonString);
      _data = jsonData['events'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connpass Search"),
      ),
      body: Column(children: <Widget>[
        Container(
          child: _buildInputField(),
        ),
        Divider(
          height: 0,
          thickness: 5,
          color: Colors.green,
          indent: 1,
          endIndent: 1,
        ),
        Expanded(
          child: _buildConnpassList(),
        )
      ]),
    );
  }

  Widget _buildInputField() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    // autovalidate: false,
                    decoration: InputDecoration(
                      hintText: '検索ワードを入力してください',
                      labelText: 'キーワードから探す',
                      labelStyle: TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withAlpha(80), width: 0),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildConnpassList() {
    return ListView.builder(
      controller: _homeController,
      itemCount: _data == null ? 0 : _data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  child: Text(
                    _dateEdit(_data[index]['started_at'].toString()),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.amber[900],
                    ),
                  ),
                  padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                ),
                Container(
                  child: Text(
                    _data[index]['catch'].toString(),
                    style: TextStyle(fontSize: 20.0, color: Colors.amber[900]),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
                ),
                Container(
                  child: Text(
                    _data[index]['address'].toString() +
                        _data[index]['place'].toString(),
                    style: TextStyle(fontSize: 20.0, color: Colors.amber[900]),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
                ),
                Divider(
                  height: 0,
                  thickness: 2,
                  color: Colors.amber,
                  indent: 1,
                  endIndent: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    this._getLocalJSONData();
  }

  String _dateEdit(String targetDate) {
    String result = "";
    if (targetDate != "") {
      DateTime startday = DateTime.parse(targetDate);
      DateFormat dateFormat = DateFormat("yyyy/mm/dd(EEE)");
      var time = targetDate.substring(11, 16);
      result = dateFormat.format(startday) + " " + time;
    }
    return result;
  }
}
