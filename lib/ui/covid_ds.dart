import 'package:covid19status/network/client/api_client.dart';
import 'package:covid19status/network/rx_converter.dart';
import 'package:rxdart/rxdart.dart';

class DataDs<T> extends RxConverter {
  Observable<dynamic> dataApi(
      String parameter) {
    return callApi(
      ApiClient().dio().get(
        parameter,
          ),
    ).map((response) {
      return returnResponse(response);
    });
  }
}