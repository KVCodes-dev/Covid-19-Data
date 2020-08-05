import 'dart:convert';

import 'package:covid19status/Base/base_repo.dart';
import 'package:covid19status/data/allData.dart';
import 'package:covid19status/data/countryData.dart';
import 'package:covid19status/network/api_manager.dart';
import 'package:covid19status/ui/covid_ds.dart';
import 'package:covid19status/ui/covid_view.dart';
import 'package:flutter/material.dart';

class DataRepo extends BaseRepo {
  final DataView view;

  DataDs _dataSource = DataDs();

  ApiManager _apiManager = new ApiManager();

  DataRepo({
    @required this.view,
  });

  void doApiCall(String parameter) async {
    view.showProgress();
    var observable = _dataSource.dataApi(parameter).map((data) {
      return AllCovidData.fromJson(jsonDecode(data.toString()));
    });
    _apiManager.subscribeObserver(observable, view);
  }

  void doApiCallCountry(String parameter) async {
    view.showProgress();
    var observable = _dataSource.dataApi(parameter).map((data) {
      print(data);
      var result;
      if (data != null) {
        result = new List<CountryCovidData>();
        data.data.forEach((v) {
          result.add(new CountryCovidData.fromJson(v));

        });
        return result;
      }else{
        return result;
      }
    });
    _apiManager.subscribeObserver(observable, view);
  }
}
