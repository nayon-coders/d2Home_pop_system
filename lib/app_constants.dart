abstract class AppConstants {
  AppConstants._();

  static const String baseUrl = "https://api.d2home.com.au/";
  static const String webUrl = "https://d2home.com.au/";

  static const bool autoTrn = true;
  static const bool isDemo = true;

  static bool playMusicOnOrderStatusChange = true;
  static bool keepPlayingOnNewOrder = true;

  static const String demoSellerLogin = 'sellers@githubit.com';
  static const String demoSellerPassword = 'seller';
  static const String demoCookerLogin = 'cook@githubit.com';
  static const String demoCookerPassword = 'cook';
  static const String demoWaiterLogin = 'waiter@githubit.com';
  static const String demoWaiterPassword = 'githubit';


  static const Duration refreshTime = Duration(seconds: 10);
  static const double demoLatitude = 41.304223;
  static const double demoLongitude = 69.2348277;
  static const double pinLoadingMin = 0.116666667;
  static const double pinLoadingMax = 0.611111111;
  static const Duration animationDuration = Duration(milliseconds: 375);

  static const double radius = 12;
}


