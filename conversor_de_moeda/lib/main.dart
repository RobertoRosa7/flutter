import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const api_HGFinance =
    'https://api.hgbrasil.com/finance?format=json-cors&key=32c83f5f';

void main() async {
  // print(await getData());

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
    );
  }
}

Future<Map> getData() async => jsonToMap(await http.get(api_HGFinance));
Future<Map> jsonToMap(res) async => await json.decode(res.body);
