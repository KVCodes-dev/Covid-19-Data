import 'dart:async';

import 'package:covid19status/Base/covid_progress.dart';
import 'package:covid19status/Base/simple_error_view.dart';
import 'package:covid19status/colors.dart';
import 'package:covid19status/data/countryData.dart';
import 'package:covid19status/ui/covid_repo.dart';
import 'package:covid19status/ui/covid_view.dart';
import 'package:flutter/material.dart';

class CountryCovidDataUi extends StatefulWidget {
  @override
  _CountryCovidDataUiState createState() => _CountryCovidDataUiState();
}

class _CountryCovidDataUiState extends State<CountryCovidDataUi>
    implements DataView {
  TextEditingController editingController = TextEditingController();
  List<CountryCovidData> countryCovidList;
  List<CountryCovidData> _searchResult = [];

  StreamController<bool> loadingState = StreamController<bool>.broadcast();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamController _controller = StreamController<List<CountryCovidData>>();
  DataRepo _dataRepo;

  @override
  void initState() {
    _dataRepo = DataRepo(view: this);
    _dataRepo.doApiCallCountry("countries");
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
        StreamBuilder<List<CountryCovidData>>(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == null) {
                countryCovidList = [];
                return Container();
              }
              countryCovidList = snapshot.data ?? [];
              return Container(
                margin: EdgeInsets.all(10.0),
                //child: _cardView(snapshot.data ?? []),
                child: _listView(),
              );
            }
            if (snapshot.hasError) {
              countryCovidList = [];
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

  Widget _listView() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            height: 55.0,
            child: TextField(
              onChanged: onSearchTextChanged,
              controller: editingController,
              style: TextStyle(color: kTextGrey, fontSize: 20.0),
              autofocus: false,
              decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  hintStyle: TextStyle(color: kTextDarkGrey),
                  labelStyle: TextStyle(color: kTextDarkGrey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: kTextDarkGrey,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: kTextGrey),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
          ),
        ),
        new Expanded(
          child: _searchResult.length != 0 || editingController.text.isNotEmpty
              ? new ListView.builder(
                  itemCount: _searchResult.length,
                  itemBuilder: (context, position) {
                    var positionData = _searchResult[position];
                    return _cardView(positionData);
                  },
                )
              : new ListView.builder(
                  itemCount: countryCovidList.length,
                  itemBuilder: (context, position) {
                    var positionData = countryCovidList[position];
                    return _cardView(positionData);
                  },
                ),
        ),
      ],
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    countryCovidList.forEach((data) {
      if (data.country.toLowerCase().contains(text.toLowerCase())) {
        _searchResult.add(data);
      }
    });
    setState(() {});
  }

  Widget _cardView(var positionData) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: kCanvas,
      shadowColor: kPrimaryDark,
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            textUI('${positionData.country}', kTextGrey, 22.0),
            heightGap(5.0),
            Row(
              children: <Widget>[
                richText('Cases : ', '${positionData.cases}', 16.0),
                textUI(' | ', kTextLight, 18.0),
                richText('Today : ', '${positionData.todayCases}', 16.0),
                textUI(' | ', kTextLight, 18.0),
                richText('Active : ', '${positionData.active}', 16.0),
              ],
            ),
            heightGap(5.0),
            Row(
              children: <Widget>[
                richText('Deaths : ', '${positionData.deaths}', 16.0),
                textUI(' | ', kTextLight, 18.0),
                richText('Today : ', '${positionData.todayDeaths}', 16.0),
              ],
            ),
            heightGap(5.0),
            Row(
              children: <Widget>[
                richText('Recovered : ', '${positionData.recovered}', 16.0),
                textUI(' | ', kTextLight, 18.0),
                richText('Critical : ', '${positionData.critical}', 16.0),
              ],
            ),
          ],
        ),
      ),
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

  Widget richText(String title, String value, double size) {
    return RichText(
      text: TextSpan(
        children: [
          new TextSpan(
            text: title,
            style: TextStyle(color: kTextDarkGrey, fontSize: size),
          ),
          new TextSpan(
            text: value,
            style: TextStyle(color: kTextGrey, fontSize: size),
          ),
        ],
      ),
    );
  }

  @override
  void hideProgress() {
    loadingState.add(false);
  }

  @override
  void onDataAvailable(data) {
    print(data);
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
    print(errorMessage);
    return SnackBar(
      content: Text(
        errorMessage,
        style: TextStyle(color: kTextBlack),
      ),
      backgroundColor: color,
    );
  }
}
