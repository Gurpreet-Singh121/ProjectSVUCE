import 'package:svuce_app/app/showToastConfigs.dart';
import 'package:svuce_app/ui/screens/admin%20screens/add_edit_time_table/add_edit_time_table.dart';

import 'consumers/imports.dart';

class MainViewModel extends BaseViewModel {
  final log = getLogger("MainViewModel");
  final UsersRepository _userRepository = locator<UsersRepository>();
  final FirebaseAuth _firebaseAuth = locator<FirebaseAuth>();
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _authService = locator<AuthService>();
  final ThemeService _themeService = locator<ThemeService>();
  final AttendanceService _attendanceService = locator<AttendanceService>();
  final TimeTableService _timeTableService = locator<TimeTableService>();
  final GithubApiServices githubApiServices = GithubApiServices();
  Graph attendanceGraph;
  bool isGuest = false;
  bool get isAdmin => _authService.hasAdminAccess;
  TimeTable timeTable;
  List<Attendance> attendanceList = [];
  List<String> subjects = [];
  UserModel _currentUser;
  bool get isDarkMode => _themeService.isDarkMode;
  UserModel get currentUser => _currentUser;
  String get name => isGuest ? "Guest" : _firebaseAuth.currentUser?.displayName;
  String get userImage => isGuest ? null : _firebaseAuth.currentUser?.photoURL;
  String get weekDay => DateTimeUtils().getWeekDay();

  String getGreeting() {
    var h = DateTime.now().hour;
    if (h < 12) {
      return "Good Morning";
    } else if (h < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  getCurrentUserDetails() {
    if (!isGuest) {
      _userRepository
          .getUserFromStream(_firebaseAuth.currentUser.email)
          .listen((event) {
        if (event != null) {
          _currentUser = event;
          _firebaseAuth.currentUser.updateProfile(
              displayName: _currentUser.fullName,
              photoURL: _currentUser.gender);
          listenTimeTable(currentUser.rollNo.toString().substring(0, 6));
          notifyListeners();
        }
      });
    }
  }

  init() {
    isGuest = _authService.isGuest;
    notifyListeners();
    if (!isGuest) {
      listenAttendanceStream();
      getCurrentUserDetails();
      getAttendanceData();
    }
  }

  getGraph() {
    List<double> temp = [];
    attendanceList.asMap().forEach((key, value) {
      if (value.total == 0) {
        temp.add(0);
      } else {
        temp.add(
            double.parse((value.present / value.total).toStringAsFixed(3)));
      }
    });
    DataSet dataSet = DataSet(
      temp,
    );
    Graph graph = Graph([
      dataSet,
    ], "", "%");
    graph.domainStart = 0;
    graph.domainEnd = temp.length >= 4 ? 4.0 : temp.length.toDouble();
    graph.rangeStart = 0;
    graph.rangeEnd = 11;
    graph.selectedDataPoint = 1;
    return graph;
  }

  listenTimeTable(String rollNo) {
    _timeTableService.getTimeTable("$rollNo").listen((event) {
      timeTable = event;
      makeSorted();
      notifyListeners();
    });
  }

  toggleTheme() async {
    await _themeService.changeTheme();
    notifyListeners();
  }

  makeSorted() {
    Map<String, dynamic> tem = timeTable.tojson();
    tem.forEach((key, value) {
      tem[key] = miniSort(value);
    });
    timeTable = TimeTable.fromMap(tem, timeTable.id);
    notifyListeners();
  }

  miniSort(Map<String, String> data) {
    Map<String, String> temp = {};
    var sortedKeys = data.keys.toList()..sort();
    sortedKeys.asMap().forEach((key, value) {
      temp[value] = data[value];
    });
    return temp;
  }

  //?Navigation Functions
  navigateToTimeTable() {
    log.i("IS ADMIN is:$isAdmin");
    if (!isAdmin) {
      _navigationService.navigateWithTransition(TimeTableView(),
          transition: "rightToLeftWithFade",
          duration: Duration(milliseconds: 900));
    } else {
      _navigationService.navigateWithTransition(AddEditTimeTableView(),
          transition: "rightToLeftWithFade",
          duration: Duration(milliseconds: 900));
    }
  }

  navigateToAttendance() {
    log.i(_authService.hasAdminAccess);

    if (_authService.hasAdminAccess) {
      _navigationService.navigateWithTransition(AttendanceStaffView(),
          transition: "rightToLeftWithFade",
          duration: Duration(milliseconds: 900));
    } else {
      _navigationService.navigateWithTransition(AttendanceManagerView(),
          transition: "rightToLeftWithFade",
          duration: Duration(milliseconds: 900));
    }
  }

  navigateToAddStudent() {
    _navigationService.navigateWithTransition(AddStudentView(),
        transition: "rightToLeftWithFade",
        duration: Duration(milliseconds: 900));
  }

  navigateToStaff() {
    _navigationService.navigateWithTransition(StaffView(),
        transition: "rightToLeftWithFade",
        duration: Duration(milliseconds: 900));
  }

  navigateToAboutCollege() {
    _navigationService.navigateWithTransition(AboutCollegeView(),
        transition: "fade", duration: Duration(milliseconds: 900));
  }

  navigateToAboutApp() {
    _navigationService.navigateWithTransition(AboutAppView(),
        transition: "fade", duration: Duration(milliseconds: 900));
  }

  navigateToExploreClubs() {
    if (isGuest) {
      showInfoToast(
        "Sorry only students of svuce can access this.",
      );
    } else {
      _navigationService.navigateWithTransition(
          SelectClubsView(
            isSelectClubs: false,
          ),
          transition: "fade",
          duration: Duration(milliseconds: 900));
    }
  }

  navigateToProfile() {
    _navigationService.navigateWithTransition(UserProfileView(),
        transition: "rightToLeftWithFade",
        duration: Duration(milliseconds: 900));
  }

  navigateToCampusMap() {
    _navigationService.navigateWithTransition(CampusMapView(),
        duration: Duration(milliseconds: 900),
        transition: "rightToLeftWithFade");
  }

  logout() async {
    setBusy(true);
    await _authService.signOut();
    setBusy(false);
  }

  getAttendanceData() async {
    await _attendanceService.init();
    notifyListeners();
  }

  listenAttendanceStream() {
    _attendanceService.getAttendanceStream().listen((event) {
      subjects.clear();
      attendanceList = event;
      attendanceList.asMap().forEach((key, value) {
        subjects.add(value.subject);
        log.wtf("Subjects are:$subjects");
        notifyListeners();
      });
    });
  }

  List<String> imageList = [
    "assets/images/ad.jpg",
    "assets/images/auditorium.jpg",
    "assets/images/hostel.webp"
  ];
}
