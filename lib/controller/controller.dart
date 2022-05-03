class Controller {
  static final Controller _instance = Controller._internal();
  static Controller getInstance() => _instance;
  Controller._internal();
  Function? reloadHome;
  Function? navigateTo;
}
