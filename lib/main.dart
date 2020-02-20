import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.amberAccent,
      ),
      home: MyHomeApp(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  @override
  _MyHomeAppState createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  String mytext;

  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      Firestore.instance.document('MyData/dummy');

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Akshay Bengani",
      "desc": "Flutter Developer",
    };

    documentReference.setData(data).then((_) {
      print('Document Added');
    }).catchError((e) {
      print(e);
    });
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print('Deleted Successfully');
      setState(() {});
    }).catchError((onError) {
      print(onError);
    });
  }

  void _update() {
    final DocumentReference documentReference =
        Firestore.instance.document('MyData/dummy');
    Map<String, String> data = <String, String>{
      "name": "Aastha Jain",
      "desc": "Product Designer",
    };
    documentReference.updateData(data);
  }

  void _fetch() {
    documentReference.get().then((datasnap) {
      if (datasnap.exists) {
        setState(() {
          mytext = datasnap.data['desc'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    subscription = documentReference.snapshots().listen((datasnap) {
      if (datasnap.exists) {
        setState(() {
          mytext = datasnap.data['desc'];
        });
      }
    });
  }
  @override
  void dispose(){
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Firebase"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: _add,
              child: Text('Add'),
              color: Colors.amberAccent,
            ),
            RaisedButton(
              onPressed: _update,
              child: Text('Update'),
              color: Colors.pinkAccent,
            ),
            RaisedButton(
              onPressed: _delete,
              child: Text('Delete'),
              color: Colors.greenAccent,
            ),
            RaisedButton(
              onPressed: _fetch,
              child: Text('Fetch'),
              color: Colors.blueAccent,
            ),
            mytext == null ? new Container() : new Text(mytext),
          ],
        ),
      ),
    );
  }
}
