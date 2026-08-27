import 'dart:io';

class Constants {
  static const dbName = 'appDB';
  static bool isFakeLocationAllowed = Platform.isAndroid ? true : true;
  static const errorRequestCancelled = 'errorRequestCancelled';
  static const errorConnectionTimeout = 'Connection Timeout';
  static const errorInternetConnection = 'Please check your Internet Connection';
  static const errorReceiveTimeout = 'errorReceiveTimeout';
  static const errorSendTimeout = 'errorSendTimeout';
  static const errorBadRequest = 'Bad Request';
  static const errorRequestNotFound = 'Request Not Found';

  static const errorInternalServer = 'Internal Server Error';
  static const errorSomethingWentWrong = 'Error Something Went Wrong';
  static int showLogs = 1;
  static int connectionTimeOut = 20000;
  static int receiveTimeOut = 20000;

  static const String PUBLIC_KEY = "your_public_key_here";
}
