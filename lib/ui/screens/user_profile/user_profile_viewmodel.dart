import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:svuce_app/app/AppSetup.logger.dart';
import 'package:svuce_app/app/locator.dart';
import 'package:svuce_app/core/models/user/user.dart';
import 'package:svuce_app/core/models/user_club/user_club.dart';
import 'package:svuce_app/core/services/auth/auth_service.dart';

import 'package:svuce_app/core/repositories/user_clubs_repository/user_clubs_repository.dart';
import 'package:svuce_app/core/services/share%20service/share_service.dart';
import 'package:svuce_app/ui/screens/Club%20Pages/select_clubs/select_clubs_view.dart';
import 'package:svuce_app/ui/screens/change%20password/change_password_view.dart';

class UserProfileViewModel extends BaseViewModel {
  // Required Services
  final AuthService _authenticationService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ShareService _shareService = locator<ShareService>();

  final UserClubsRepository _userClubsRepository =
      locator<UserClubsRepository>();
  navigateToChangePassword() {
    _navigationService.navigateWithTransition(ChangePasswordView(),
        transition: "rightToLeftWithFade",
        duration: Duration(milliseconds: 900));
  }

  final log = getLogger('User Profile View Model');
  List<Map<String, dynamic>> socialLinksData = [
    {
      "name": "Youtube",
      "link":
          "https://www.youtube.com/channel/UCt6zvDyrdSCivo-6sPsJDwA/featured",
      "icon": FlutterIcons.youtube_ant,
      "color": Color(0xFFFF0000)
    },
    {
      "name": "Instagram",
      "link": "https://www.instagram.com/svucesv?r=nametag",
      "icon": FlutterIcons.instagram_ant,
      "color": Color(0xFFDD915E)
    },
    {
      "name": "Twitter",
      "link": "https://twitter.com/svucesv",
      "icon": FlutterIcons.twitter_ant,
      "color": Color(0xFF1DA1F2)
    },
    {
      "name": "Facebook",
      "link": "https://www.facebook.com/SvuceSV",
      "icon": FlutterIcons.facebook_square_ant,
      "color": Color(0xFF4267B2),
    }
  ];

  UserModel user;

  List<UserClub> _userClubs;
  List<UserClub> get userClubs => _userClubs;

  bool get hasUserClubs => _userClubs != null && _userClubs.isNotEmpty;

  init() {
    var currentUser = _authenticationService.currentUser;
    log.d(currentUser);
    if (currentUser != null) {
      user = currentUser;
      getUserClubList(currentUser.email);
    }
  }

  getUserClubList(String userId) {
    setBusy(true);
    _userClubsRepository.getUserClubs(userId).listen((clubsData) {
      List<UserClub> updatedPosts = clubsData;
      print(updatedPosts);
      if (updatedPosts != null && updatedPosts.length > 0) {
        _userClubs = updatedPosts;
        notifyListeners();
      }
    });
    setBusy(false);
  }

  navigateToRegisterClub() {
    _navigationService.navigateWithTransition(
        SelectClubsView(
          isSelectClubs: true,
        ),
        transition: "scale");
  }

  launchUrl(String url) {
    _shareService.launchUrl(urlLink: url);
  }

  goBack() => _navigationService.back();
}
