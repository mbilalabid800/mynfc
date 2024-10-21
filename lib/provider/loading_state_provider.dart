import 'package:flutter/material.dart';

class LoadingStateProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _dataFetched = false;

  bool get isLoading => _isLoading;
  bool get dataFetched => _dataFetched;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setDataFetched(bool fetched) {
    _dataFetched = fetched;
    notifyListeners();
  }
}
