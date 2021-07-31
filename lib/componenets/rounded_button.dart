import 'package:flutter/material.dart';

// ignore: camel_case_types
class mybutton extends StatelessWidget {
  mybutton({this.colour,this.text, this.func});
  final Color colour;
  final Text text;
  final Widget func;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
            onPressed: () {
              // ignore: missing_return
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return func;
                  }));
            },
            minWidth: 200.0,
            height: 42.0,
            child: text
        ),
      ),
    );
  }
}
