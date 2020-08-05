import 'package:covid19status/colors.dart';
import 'package:covid19status/covid_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(CovidApp());

class CovidApp extends StatefulWidget {
  @override
  _CovidAppState createState() => _CovidAppState();
}

class _CovidAppState extends State<CovidApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid 19 Information',
      theme: ThemeData(
        primaryColor: kPrimary,
        primaryColorDark: kPrimaryDark,
        accentColor: kAccent,
        canvasColor: kCanvas,
      ),
      home: CovidPage(title: 'Covid 19 Information'),
    );
  }
}

