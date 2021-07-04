import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:svuce_app/app/AppSetup.router.dart';
import 'package:svuce_app/app/colors.dart';
import 'package:svuce_app/app/locator.dart';
import 'package:svuce_app/app/setupSnackbarUi.dart';
import 'package:svuce_app/app/theme.dart';

import 'core/services/firebaseAnalyticsService.dart';
import 'core/services/theme_service.dart';
import 'hive_db/setup_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupLocator();
  setupSnackbarUi();
  setupHive();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      onModelReady: (model) => model.initTheme(),
      viewModelBuilder: () => AppViewModel(),
      builder: (context, model, child) => OKToast(
        position: ToastPosition.bottom,
        backgroundColor: model.isDarkMode
            ? DarkColorPalette.backgroundColor
            : LightColorPalette.backgroundColor,
        child: MaterialApp(
          title: 'SVUCE ',
          navigatorObservers: [
            locator<AnalyticsService>().getAnalyticsObserver(),
          ],
          builder: (context, widget) => widget,
          darkTheme: darkThemeData(context),
          themeMode: model.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: model.isDarkMode
              ? darkThemeData(context)
              : lightThemeData(context),
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class AppViewModel extends ReactiveViewModel {
  final ThemeService _themeService = locator<ThemeService>();
  bool get isDarkMode => _themeService.isDarkMode;
  initTheme() {
    _themeService.getThemeMode();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_themeService];
}
