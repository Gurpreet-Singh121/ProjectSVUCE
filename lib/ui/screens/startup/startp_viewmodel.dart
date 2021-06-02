import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:svuce_app/app/AppSetup.logger.dart';
import 'package:svuce_app/app/assets.dart';
import 'package:svuce_app/app/locator.dart';
import 'package:svuce_app/core/repositories/users_repository/users_repository.dart';
import 'package:svuce_app/core/services/auth/auth_service.dart';

import 'package:svuce_app/app/AppSetup.router.dart';

import 'package:svuce_app/core/services/dynamic_links/dynamic_links.dart';
import 'package:svuce_app/core/services/firebaseAnalyticsService.dart';
import 'package:svuce_app/core/services/one_signal_service.dart';

class StartUpViewModel extends BaseViewModel {
  final log = getLogger("Startup View Model");
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final OneSignalService _notificationService = OneSignalService();
  final DynamicLinkService _dynamicLinkService = locator<DynamicLinkService>();
  final UsersRepository _usersRepository = locator<UsersRepository>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();

  Future handleStartUpLogic(BuildContext context) async {
    _analyticsService.logAppOpen();
    await precacheImage(AssetImage(hexagonPattern), context);

    await _dynamicLinkService.handleDynamicLinks();
    await _notificationService.initialise();
    var userLoggedIn = _authenticationService.isUserLoggedIn();
    log.i("User Login Status is:$userLoggedIn");
    if (userLoggedIn) {
      _usersRepository.getUserDetailsFromPrefs();
      _navigationService.navigateTo(Routes.mainView);
    } else {
      _navigationService.navigateTo(Routes.entryView);
    }
  }
}
