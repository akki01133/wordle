import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }

  bool _isError = false;
  get isError => _isError;
  set isError(value) {
    _isError = value;
  }

  String _message = '';
  get message => _message;
  set message(value) {
    _message = value;
  }

  enableLoadingState(){
    isError = false;
    message = '';
    isBusy = true;
  }

  //todo - improvise auth state error {show dialog}
  enableErrorState( error, {VoidCallback? errorCallback}){
    isError = true;
    message = error;
    if(errorCallback != null) errorCallback();
    print(error);
    isBusy = false;
  }
}
