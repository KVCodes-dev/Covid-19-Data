import 'package:covid19status/colors.dart';
import 'package:covid19status/ui/all_covid.dart';
import 'package:covid19status/ui/country_covid.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CovidPage extends StatefulWidget {
  CovidPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {
  var currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kCanvas,
        title: Text(
          widget.title,
          style: (TextStyle(color: kTextDarkGrey)),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: kBackgroundDark,
        height: 55.0,
        color: kCanvas,
        items: <Widget>[
          Icon(
            Icons.language,
            size: 20,
            color: kTextGrey,
          ),
          Icon(
            Icons.flag,
            size: 20,
            color: kTextGrey,
          ),
        ],
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
          print(index);
        },
      ),
      body: _body(),
    );
  }

  Widget _body() {
    switch (currentPage) {
      case 0:
        return AllCovidDataUi();
        break;
      case 1:
        return CountryCovidDataUi();
        break;
      default:
        return AllCovidDataUi();
        break;
    }
  }
}
