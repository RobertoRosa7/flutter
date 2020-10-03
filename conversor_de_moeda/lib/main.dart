import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const api_HGFinance =
    'https://api.hgbrasil.com/finance?format=json-cors&key=32c83f5f';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      // inputDecorationTheme: InputDecorationTheme(
      //   enabledBorder:
      //       OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      //   focusedBorder:
      //       OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
      //   hintStyle: TextStyle(color: Colors.amber),
      // )
    ),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  void _realChange(String text) {
    if (text.isEmpty) {
      resetAllFields();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChange(String text) {
    if (text.isEmpty) {
      resetAllFields();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      resetAllFields();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    euroController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  void resetAllFields() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando...",
                  style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error ao carregar!",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy'];
                euro = snapshot.data['results']['currencies']['EUR']['buy'];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          'Reais', 'R\$ ', realController, _realChange),
                      Divider(),
                      buildTextField(
                          'Dólares', 'US\$ ', dolarController, _dolarChange),
                      Divider(),
                      buildTextField('Euros', '€ ', euroController, _euroChange)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Future<Map> getData() async => jsonToMap(await http.get(api_HGFinance));
Future<Map> jsonToMap(http.Response res) async => await json.decode(res.body);

Widget buildTextField(
    String label, String prefix, TextEditingController ctrl, Function f) {
  return TextField(
    controller: ctrl,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
