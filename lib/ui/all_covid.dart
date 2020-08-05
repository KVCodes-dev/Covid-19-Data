import 'dart:async';

import 'package:covid19status/Base/covid_progress.dart';
import 'package:covid19status/Base/simple_error_view.dart';
import 'package:covid19status/colors.dart';
import 'package:covid19status/data/allData.dart';
import 'package:covid19status/ui/covid_repo.dart';
import 'package:covid19status/ui/covid_view.dart';
import 'package:flutter/material.dart';

class AllCovidDataUi extends StatefulWidget {
  @override
  _AllCovidDataUiState createState() => _AllCovidDataUiState();
}

class _AllCovidDataUiState extends State<AllCovidDataUi> implements DataView {
  StreamController<bool> loadingState = StreamController<bool>.broadcast();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController _controller = StreamController<AllCovidData>();
  DataRepo _dataRepo;

  @override
  void initState() {
    _dataRepo = DataRepo(view: this);
    _dataRepo.doApiCall("all");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBackgroundDark,
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: <Widget>[
        StreamBuilder<AllCovidData>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Container();
              }
              return Container(
                margin: EdgeInsets.all(20.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        textUI("Total Cases", kTextDarkGrey, 18.0),
                        heightGap(5.0),
                        textUI("${snapshot.data.cases}", kTextGrey, 22.0),
                        heightGap(20.0),
                        textUI("Deaths", kTextDarkGrey, 18.0),
                        heightGap(5.0),
                        textUI("${snapshot.data.deaths}", kTextGrey, 22.0),
                        heightGap(20.0),
                        textUI("Recoverd", kTextDarkGrey, 18.0),
                        heightGap(5.0),
                        textUI("${snapshot.data.recovered}", kTextGrey, 22.0)
                      ],
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              print('Data ERROR: ${snapshot.error}');
              return SimpleErrorView(
                messageKey: snapshot.error,
                textColor: kTextLight,
              );
            }
            return Container();
          },
        ),
        StreamBuilder(
          stream: loadingState.stream,
          builder: (context, snapshot) {
            if (snapshot.data ?? false) {
              return CovidProgress();
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget textUI(String label, Color color, double fontSize) {
    return Text(
      label,
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }

  Widget heightGap(double size) {
    return SizedBox(
      height: size,
    );
  }

  @override
  void hideProgress() {
    loadingState.add(false);
  }

  @override
  void onDataAvailable(data) {
    _controller.add(data);
  }

  @override
  void onError(String key) {
    _showDialog(key);
  }

  @override
  void showError(String errorMessage) {
    var snackBar = snackBarView(errorMessage, kTextGrey);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void showProgress() {
    loadingState.add(true);
  }

  _showDialog(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => new AlertDialog(
        backgroundColor: kTextLight,
        title: new Text(message),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              "Okay",
              style: TextStyle(color: kBackgroundDark),
            ),
          ),
        ],
      ),
    );
  }

  snackBarView(String errorMessage, Color color) {
    return SnackBar(
      content: Text(errorMessage),
      backgroundColor: color,
    );
  }
}
