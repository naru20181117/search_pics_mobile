import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final String url = "https://connpass.com/api/v1/event/?count=20&order=3";
  final _formKey = GlobalKey<FormState>();
  var _searchQuery = "";

  // Future<String> _loadAVaultAsset() async {
  //   return await rootBundle.loadString('json/api_local_connpass.json');
  // }

  // Future<String> _getLocalJSONData() async {
  //   String jsonString = await _loadAVaultAsset();

  //   setState(() {
  //     final jsonData = json.decode(jsonString);
  //     _data = jsonData['events'];
  //   });
  // }

  Future<String> _getHttpJSONData(String keyWord) async {
    var _requestURL = url;

    if (keyWord.isNotEmpty) {
      _requestURL = url + "&keyword=" + keyWord;
    }
    print('URL:' + _requestURL);

    var response = await http.get(Uri.encodeFull(_requestURL),
        headers: {"Content-Type": "application/json"});

    setState(() {
      final jsonData = json.decode(response.body);
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
      key: _formKey,
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
                    validator: (value) {
                      if (value.isEmpty) {
                        _searchQuery = "";
                      }
                      return null;
                    },
                    onSaved: (val) => _searchQuery = val,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 40.0,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _startSearch();
                  },
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
                GestureDetector(
                  onTap: () {
                    _externalBrowser(_data[index]['event_url'].toString());
                  },
                  child: Container(
                    child: Text(
                      _data[index]['title'].toString(),
                      style: TextStyle(
                          fontSize: 20.0,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                    ),
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                  ),
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

    // this._getLocalJSONData();
    this._getHttpJSONData("");
  }

  String _dateEdit(String targetDate) {
    String result = "";
    if (targetDate != "") {
      DateTime startday = DateTime.parse(targetDate);
      DateFormat dateFormat = DateFormat("yyyy/MM/dd(EEE)");
      var time = targetDate.substring(11, 16);
      result = dateFormat.format(startday) + " " + time;
    }
    return result;
  }

  void _startSearch() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    print('検索条件:' + this._searchQuery);

    _homeController.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));

    this._getHttpJSONData(this._searchQuery);
  }

  void _externalBrowser(String pageUrl) async {
    if (await canLaunch(pageUrl)) {
      await launch(pageUrl);
    } else {
      throw 'Could not launch $pageUrl';
    }
  }
}
