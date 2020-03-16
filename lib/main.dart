import 'package:love_voice/pages/email.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Button(),
    routes: <String, WidgetBuilder>{
      "/Email": (BuildContext context) => MyEmail()
    },
  ));
}

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              child: RaisedButton(
                child: Text('Email'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyEmail()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
