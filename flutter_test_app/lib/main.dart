import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_test_app/comunica.dart';
import 'package:flutter_test_app/ldflex.dart';
import 'package:js/js_util.dart';
import './stringify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var rubenProfile = LDflexWidgetFactory([
    'https://ruben.verborgh.org/profile/'
  ], {
    "context": {
      "@context": {
        "@vocab": "http://xmlns.com/foaf/0.1/",
        "friends": "knows",
        "label": "http://www.w3.org/2000/01/rdf-schema#label",
        "rbn": "https://ruben.verborgh.org/profile/#",
      },
    }
  });

// Create entity we are interested in within the document
LDflexWidget ruben = rubenProfile('https://ruben.verborgh.org/profile/#me');

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ruben['label'],
            const Text(' is interested in '),
            ruben['interest']['label']
          ],
        ),
      ),
    );
  }
}
