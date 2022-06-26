import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=ed5d1455");

void main() async {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder:
          OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController realController = TextEditingController();
  TextEditingController dolarController = TextEditingController();
  TextEditingController euroController = TextEditingController();

  late double dolar;
  late double euro;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$ Conversor \$', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),),
        backgroundColor: Colors.amber,
        //titleTextStyle: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),
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
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                        //buildTextField("Reais", "R\$", realController, _realChanged),
                        TextField(
                          controller: realController,
                          style: TextStyle(color: Colors.amber, fontSize: 25,),
                          decoration: InputDecoration(
                            labelText: "Reais",
                            labelStyle: TextStyle(color: Colors.amber),
                            prefixText: "R\$ ",
                            prefixStyle: TextStyle(color: Colors.amber, fontSize: 20),
                          ),
                          onChanged: _realChanged,
                          keyboardType: TextInputType.number,
                        ),

                        Divider(),
                        //buildTextField("Dólares", "US\$ ", dolarController, _dolarChanged),
                        TextField(
                          controller: dolarController,
                          style: TextStyle(color: Colors.amber, fontSize: 25,),
                          decoration: InputDecoration(
                            labelText: "Dólares",
                            labelStyle: TextStyle(color: Colors.amber),
                            prefixText: "US\$ ",
                            prefixStyle: TextStyle(color: Colors.amber, fontSize: 20),
                          ),
                          onChanged: _dolarChanged,
                          keyboardType: TextInputType.number,
                        ),
                        Divider(),
                        //buildTextField("Euros", "€\$ ", euroController, _euroChanged),
                        TextField(
                          controller: euroController,
                          style: TextStyle(color: Colors.amber, fontSize: 25,),
                          decoration: InputDecoration(
                            labelText: "Euros",
                            labelStyle: TextStyle(color: Colors.amber),
                            prefixText: "€\$ ",
                            prefixStyle: TextStyle(color: Colors.amber, fontSize: 20),
                          ),
                          onChanged: _euroChanged,
                          keyboardType: TextInputType.number,
                        ),
                        //Divider(),
                        //buildTextField("Euros", "€\$ ", euroController, _euroChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    style: TextStyle(color: Colors.amber, fontSize: 25,),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      prefixText: prefix,
      prefixStyle: TextStyle(color: Colors.amber, fontSize: 20),
    ),
    onChanged: (String value) {
      f(c.toString());
    },
    keyboardType: TextInputType.number,
  );
}



















