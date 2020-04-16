import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:svuce_app/constants/route_paths.dart';
import 'package:svuce_app/services/authentication_service.dart';
import 'package:svuce_app/services/base_auth.dart';
import 'package:svuce_app/services/dialog_service.dart';
import 'package:svuce_app/services/navigation_service.dart';

import '../locator.dart';
import 'base_model.dart';

class LoginViewModel extends BaseModel {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> get formKey => _formKey;

  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthenticationService _authenticationService = locator<BaseAuth>();

  String validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please Enter Your Email';
    } else if (email.length < 5) {
      return 'Your email mush be atleast 6';
    }
    return null;
  }

  String validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please Enter Your Password';
    } else if (password.length < 5) {
      return 'Your password mush be atleast 6';
    }
    return null;
  }

  void login() async {
    bool result = _formKey.currentState.validate();

    if (!result) {
      return null;
    }

    String email = emailController.text;
    String password = passwordController.text;

    setBusy(true);

    var authResult = await _authenticationService.loginUser(
        email: email, password: password);

    setBusy(false);

    if (authResult is bool) {
      if (authResult) {
        _navigationService.navigateTo(HomeViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Login Failure',
          description: 'General login failure, please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
          title: 'Login Failure', description: authResult);
    }
  }

  gotoSignup() {
    _navigationService.navigateTo(SignUpViewRoute);
  }

  Future<bool> onWillPop() async {
    var isPressed = await _dialogService.showDialog(
        title: 'Exit',
        description: 'Are you sure to exit?',
        buttonTitle: 'Yes');

    if (isPressed.confirmed) {
      exit(0);
    }

    return false;
  }
}
