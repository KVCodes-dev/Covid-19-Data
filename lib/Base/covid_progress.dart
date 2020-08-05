import 'package:covid19status/colors.dart';
import 'package:flutter/material.dart';

class CovidProgress extends StatefulWidget {
  @override
  _CovidProgressState createState() => _CovidProgressState();
}

class _CovidProgressState extends State<CovidProgress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kTextGrey),),
        ),
      ),
    );
  }
}
