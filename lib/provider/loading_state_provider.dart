import 'package:flutter/material.dart';

class LoadingStateProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _dataFetched = false;
  int _selectedIndex = 0;

  bool get isLoading => _isLoading;
  bool get dataFetched => _dataFetched;
  int get selectedIndex => _selectedIndex;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setDataFetched(bool fetched) {
    _dataFetched = fetched;
    notifyListeners();
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
