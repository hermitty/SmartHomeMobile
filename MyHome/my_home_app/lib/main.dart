import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> fanOn() async {
    var url =
        'http://192.168.43.93:8081/json.htm?type=command&param=switchlight&idx=3&switchcmd=On&level=0&passcode=';
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> fanOff() async {
    var url =
        'http://192.168.43.93:8081/json.htm?type=command&param=switchlight&idx=3&switchcmd=Off&level=0&passcode=';
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> lampOn() async {
    var url =
        'http://192.168.43.93:8081/json.htm?type=command&param=switchlight&idx=11&switchcmd=On&level=0&passcode=';
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> lampOff() async {
    var url =
        'http://192.168.43.93:8081/json.htm?type=command&param=switchlight&idx=11&switchcmd=Off&level=0&passcode=';
    var response = await http.post(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<void> getData() async {
    var url =
        'http://192.168.43.93:8081/json.htm?type=devices&filter=all&used=true&favorite=1&order=[Order]&plan=0';
        http.Response response;
        try{
        response = await http.get(url);
        }
        catch(Exception)
        {
          return;
        }
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Map jsonData = json.decode(response.body.toString());

    setState(() {
      temperature = jsonData["result"][1]["Temp"];
      lastSeen = jsonData["result"][2]["LastUpdate"];
    });
  }

  bool lamp = false;
  bool fan = false;
  bool smart = false;
  double temperature;
  String lastSeen;
  Color smartColor = Colors.blueGrey;
  Color smartColor2 = Colors.white;
  Color fanColor = Colors.blueGrey;
  Color fanColor2 = Colors.white;
  Color lampColor = Colors.blueGrey;
  Color lampColor2 = Colors.white;

  @override
  Widget build(BuildContext context) {
    getData();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          "My Smart Home",
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Ink(
                decoration: ShapeDecoration(
                  color: smartColor,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  iconSize: 80,
                  icon: Icon(Icons.home),
                  color: smartColor2,
                  onPressed: () {
                    setState(() {
                      if (!smart) {
                        smartColor = Colors.lightGreen;
                      } else {
                        smartColor = Colors.blueGrey;
                      }
                      smart = !smart;
                    });
                  },
                )),
            Row(
              children: <Widget>[
                Expanded(
                  child: Ink(
                      decoration: ShapeDecoration(
                        color: fanColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 80,
                        icon: Icon(Icons.ac_unit),
                        color: fanColor2,
                        onPressed: () {
                          setState(() {
                            if (!fan) {
                              fanColor = Colors.lightGreen;
                            
                              fanOn();
                            } else {
                              fanColor = Colors.blueGrey;
          
                              fanOff();
                            }
                            fan = !fan;
                          });
                        },
                      )),
                ),
                Expanded(
                  child: Ink(
                      decoration: ShapeDecoration(
                        color: lampColor,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        iconSize: 80,
                        icon: Icon(Icons.lightbulb_outline),
                        color: lampColor2,
                        onPressed: () {
                          setState(() {
                            if (!lamp) {
                              lampColor = Colors.lightGreen;
                              lampOn();
                            } else {
                              lampColor = Colors.blueGrey;
                              lampOff();
                            }
                            lamp = !lamp;
                          });
                        },
                      )),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(40.0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 33),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5),
              ), //       <--- BoxDecoration here
              child: Text(
                '$temperature °C',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Text(
              'Last seen',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              '$lastSeen',
              
            ),
          ],
        ),
      ),
    );
  }
}
