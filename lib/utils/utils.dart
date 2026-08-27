import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/models/response/login_response/Author.dart';
import 'package:flutter_base/models/response/login_response/Data.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/response/login_response/Room.dart';
import 'package:flutter_base/models/response/login_response/Category.dart' as loginCategory;
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/response/book_response/Author.dart';
import '../models/response/book_response/Self.dart';
import '../models/response/login_response/BookBaseData.dart';
import '../models/response/login_response/Country.dart';
import '../models/response/login_response/Donor.dart';
import '../models/response/login_response/LibraryLogin.dart';
import 'colors.dart';

class Utils {
  static Future<void> setIsDownload(bool isDownload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("download_count", isDownload);
  }

  static Future<bool> getIsDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDownload = prefs.getBool("download_count");
    return isDownload ?? false;
  }
  static Future<void> saveSelectedLibraryForRole(
      LibraryLogin library, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_library_$role', jsonEncode(library.toJson()));
  }
  static Future<LibraryLogin?> getSelectedLibraryForRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('selected_library_$role');
    if (data != null) {
      return LibraryLogin.fromJson(jsonDecode(data));
    }
    return null;
  }

  static Future<void> removeIsDownload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("download_count");
  }

  static void setAccessToken(String accesToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", accesToken);
  }
  static Future<void> setLibrariesList(List<LibraryLogin> libraries) async {
    final prefs = await SharedPreferences.getInstance();
    final librariesJson =
    libraries.map((lib) => lib.toJson()).toList();
    await prefs.setString('libraries_list', jsonEncode(librariesJson));
  }

  static Future<List<LibraryLogin>> getLibrariesList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('libraries_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => LibraryLogin.fromJson(e)).toList();
    }
    return [];
  }
  static Future<void> setPlatformPackageList(List<PlatformPackage> packages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = packages.map((e) => e.toJson()).toList();
    await prefs.setString('platform_package_list', jsonEncode(jsonList));
  }

  static Future<List<PlatformPackage>> getPlatformPackageList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('platform_package_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => PlatformPackage.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> setPaymentMethodsList(List<PaymentMethod> methods) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = methods.map((e) => e.toJson()).toList();
    await prefs.setString('payment_methods_list', jsonEncode(jsonList));
  }

  static Future<List<PaymentMethod>> getPaymentMethodsList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('payment_methods_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => PaymentMethod.fromJson(e)).toList();
    }
    return [];
  }
  static Future<void> setCountriesList(List<Country> countries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = countries.map((e) => e.toJson()).toList();
    await prefs.setString('countries_list', jsonEncode(jsonList));
  }

  /// Get countries list from SharedPreferences
  static Future<List<Country>> getCountriesList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('countries_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Country.fromJson(e)).toList();
    }
    return [];
  }
  // static Future<void> setBookShelves(List<Shelf> shelf) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonList = shelf.map((e) => e.toJson()).toList();
  //   await prefs.setString('shelves_list', jsonEncode(jsonList));
  // }
  static Future<List<Shelf>> getShelfList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('shelves_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Shelf.fromJson(e)).toList();
    }
    return [];
  }
  static Future<void> setAuthorBaseDataList(List<AuthorBaseData> authorBaseData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = authorBaseData.map((e) => e.toJson()).toList();
    await prefs.setString('authors_list', jsonEncode(jsonList));
  }
  static Future<List<AuthorBaseData>> getAuthorsBaseDataList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('authors_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => AuthorBaseData.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<loginCategory.Category>> getCategoryList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('categories_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => loginCategory.Category.fromJson(e)).toList();
    }
    return [];
  }
  static Future<List<Country>> getCountryList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('countries_list'); // your key in prefs

    if (data != null) {
      final Map<String, dynamic> jsonData = jsonDecode(data);

      // Extract 'countries' array
      final List<dynamic> jsonList = jsonData['countries'] ?? [];

      // Convert to List<Country>
      return jsonList.map((e) => Country.fromJson(e)).toList();
    }

    return [];
  }
  static Future<void> saveBookLists(BookBaseData book) async {
    final prefs = await SharedPreferences.getInstance();


    if (book.categories != null) {
      final categoriesJson = book.categories!.map((e) => e.toJson()).toList();
      await prefs.setString('categories_list', jsonEncode(categoriesJson));
    }

    // Save Authors
    if (book.authors != null) {
      final authorsJson = book.authors!.map((e) => e.toJson()).toList();
      await prefs.setString('authors_list', jsonEncode(authorsJson));
    }

    // Save Rooms
    if (book.rooms != null) {
      final roomsJson = book.rooms!.map((e) => e.toJson()).toList();
      await prefs.setString('rooms_list', jsonEncode(roomsJson));
    }
    if (book.shelves != null) {
      final shelvesJson = book.shelves!.map((e) => e.toJson()).toList();
      await prefs.setString('shelves_list', jsonEncode(shelvesJson));
    }

    if (book.donors != null) {
      final donorsJson = book.donors!.map((e) => e.toJson()).toList();
      await prefs.setString('donors_list', jsonEncode(donorsJson));
    }
  }
  static Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }
  //TODO:: GET ROOM Data
  static Future<List<Room>> getRoomList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('rooms_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Room.fromJson(e)).toList();
    }
    return [];
  }

  static Future<List<Donor>> getDonorList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('donors_list');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => Donor.fromJson(e)).toList();
    }
    return [];
  }
  static Future<void> removeAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  static void setIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_logged_in", isLoggedIn);
  }

  static Future<bool> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("is_logged_in");
    return isLoggedIn ?? false;
  }

  static Future<void> removeIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("is_logged_in");
  }

  static void setUserData(Data userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_data", jsonEncode(userData.toJson()));
  }

  static Future<Data?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString("user_data");
    if (data != null) {
      Data userData = Data.fromJson(jsonDecode(data));
      return userData;
    } else {
      return null;
    }
  }

  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("user_data");
  }

  static Future<void> clearCacheData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  // static Future<bool> isAllPermissionsGranted() async {
  //   // TrackingStatus trackingStatus =
  //   //     await AppTrackingTransparency.requestTrackingAuthorization();
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.camera,
  //     Permission.storage,
  //   ].request();
  //   // print(trackingStatus);
  //   if (statuses[Permission.storage]!.isGranted) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static Future<bool> isAllPermissionsGranted() async {
    Map<Permission, PermissionStatus> statuses;

    if (Platform.isAndroid && (await getAndroidVersion()) >= 33) {

      statuses = await [
        Permission.camera,
        Permission.photos, // For images// For audio
      ].request();

    } else {
      // Android 12 and below (API 32 and lower)
      statuses = await [
        Permission.camera,
        Permission.storage, // For general file storage
      ].request();
    }

    // Check if all required permissions are granted
    return statuses.values.every((status) => status.isGranted);
  }

// Function to get Android version
  static Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;

    }
    return 0; // Default for non-Android
  }

  static Future<void> requestForPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.notification,
    ].request();
  }

  static String? validateFields(String? value, {required String errorText}) {
    if (value != null) {
      if (value.isEmpty) {
        return errorText;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
  static void printInDebug(dynamic object) {
    if (kDebugMode) {
      print(object);
    }
  }

  static DateTime getFormattedDate(String date) {
    DateFormat inputFormat2 = DateFormat('yyyy-MM-dd hh:mm a');
    return inputFormat2.parse(date);
  }

  static String checkNullString(bool prefix) {
    var value = '';
    if (prefix) {
      value = ',N/A';
    } else {
      value = 'N/A';
    }

    return value;
  }

  static InputDecoration dropdownInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: ColorUtils.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: ColorUtils.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: ColorUtils.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: ColorUtils.redColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      // suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 18.w,
      ),
      hintText: dropdownHintText,
    );
  }

  static Future<void> launchWebUrl(String url) async {
    if (Platform.isAndroid) {
      if (await canLaunchUrl(Uri.parse(url))) {
        launchUrl(Uri.parse(url));
      } else {
        Fluttertoast.showToast(msg: 'Unable to update');
      }
    }
  }

  static showUpdateDialog(
      {required String message, required BuildContext context}) {
    DialogBuilder.showLogoutDialog(
        title: "Alert",
        content: message,
        context: context,
        isCancelable: false,
        callback: () async {
          Navigator.pop(context);
          // await Utils.launchWebUrl(EnvironmentConfig.BASE_URL_LIVE);
        },
        buttonText: 'Ok');
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes <= 0) return "0 Bytes";
    const suffixes = ["Bytes", "KB", "MB", "GB", "TB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) +
        suffixes[i];
  }

  static Future<File> compressAndGetFile(File file, String targetPath,
      {int? sameSizeCompressionCount,
      int? previousImageCompressedFileSize}) async {
    File imageFile = File(file.path);
    int imageBytes = (imageFile.readAsBytesSync()).length;
    String fileSize = getFileSizeString(bytes: imageFile.lengthSync());
    double imageFileSize = 0;
    final dir = await getTemporaryDirectory();
    // double imagesAsMBs =
    //     ((double.parse(imageBytes.toString())) / 1024.0) / 1024.0;
    if (fileSize.contains("Bytes")) {
      double value = double.parse(((fileSize.split("Bytes")).first).toString());
      imageFileSize = (value / 1024.0) / 1024.0;
    }
    if (fileSize.contains("KB")) {
      double value = double.parse(((fileSize.split("KB")).first).toString());
      imageFileSize = value / 1024.0;
    }
    if (fileSize.contains("MB")) {
      double value = double.parse(((fileSize.split("MB")).first).toString());
      imageFileSize = value;
    }
    if (fileSize.contains("GB")) {
      double value = double.parse(((fileSize.split("GB")).first).toString());
      imageFileSize = value * 1024.0;
    }
    if (fileSize.contains("TB")) {
      double value = double.parse(((fileSize.split("TB")).first).toString());
      imageFileSize = (value * 1024.0) * 1024.0;
    }
    double maxFileSize = 0;
    if (Platform.isIOS) {
      maxFileSize = 0.68359375;
    } else {
      maxFileSize = 0.29296875;
    }
    if (imageFileSize > maxFileSize) {
      // return false;
      if (imageBytes == (previousImageCompressedFileSize ?? 0)) {
        if (sameSizeCompressionCount == 1) {
          return imageFile;
        } else {
          sameSizeCompressionCount = (sameSizeCompressionCount ?? 0) + 1;
        }
      } else {
        sameSizeCompressionCount = 0;
      }
      try {
        XFile? result;
        if (Platform.isIOS) {
          result = await FlutterImageCompress.compressAndGetFile(
            imageFile.path,
            '${dir.absolute.path}/temp${DateTime.now().microsecondsSinceEpoch}.jpg',
            quality: 20,
          );
        } else {
          result = await FlutterImageCompress.compressAndGetFile(
            imageFile.path,
            '${dir.absolute.path}/temp${DateTime.now().microsecondsSinceEpoch}.jpg',
            quality: 40,
          );
        }
        previousImageCompressedFileSize =
            ((File(result!.path)).readAsBytesSync()).length;
        return await compressAndGetFile(File(result.path), targetPath,
            sameSizeCompressionCount: sameSizeCompressionCount,
            previousImageCompressedFileSize: previousImageCompressedFileSize);
      } catch (ex, stack) {
        debugPrintStack(label: ex.toString(), stackTrace: stack);
        return imageFile;
      }
    } else {
      return imageFile;
    }
  }

  static String? validateCnic(String? value) {
    if ((value?.isEmpty ?? true) || value == null) {
      return validationErrorCnicEmptyText;
    } else if (value.length < 15) {
      return validationErrorCnicText;
    } else {
      return null;
    }
  }

  static String? validateMobileNumber(String? value) {
    if ((value?.isEmpty ?? true) || value == null) {
      return validationErrorMobileEmptyText; // Custom error message for empty input
    } else if (value.length != 12) {
      return validationErrorMobileText; // Custom error message for invalid length
    } else {
      return null; // No error, valid input
    }
  }

  static Future<bool> isInternetAvailable() async {
    bool available = await InternetConnection().hasInternetAccess;
    return available;
  }

  static String? validatePassword(String? value) {
    if ((value?.length ?? 0) < 8) {
      return validationErrorCnicText;
    } else {
      return null;
    }
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static Future<void> checkPermissionAndGetCurrentLocation(
      BuildContext context, Function(Position) location) async {
    // Check location permission
    PermissionStatus permission = await Permission.location.status;

    if (permission.isGranted) {
      _getCurrentLocation((position) {
        location(position);
      });
    } else if (permission.isDenied) {
      PermissionStatus newPermission = await Permission.location.request();
      if (newPermission.isGranted) {
        _getCurrentLocation((position) {
          location(position);
        });
      }
    } else if (permission.isPermanentlyDenied) {
      Utils.showToast(allowAllPermissionText);
      await openAppSettings();
    } else {
      PermissionStatus newPermission = await Permission.location.request();
      if (newPermission.isGranted) {
        _getCurrentLocation((position) {
          location(position);
        });
      } else {
        _showPermissionDeniedMessage(context);
      }
    }
  }

  static void _showPermissionDeniedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location permission is required to open Google Maps.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static Future<void> _getCurrentLocation(
      Function(Position) currentPosition) async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition(position);
  }

  static double bytesToMegabytes(int bytes) {
    return bytes / (1024 * 1024);
  }

  static String getDateFormatAntiDengue(String dateTime) {
    if (dateTime.isEmpty) {
      return "N/A";
    }

    try {
      // Parse the ISO 8601 formatted date string
      DateTime parsedDate = DateTime.parse(dateTime);

      // Format the date to the desired format: "17, Jan 2025, 05:42 AM"
      String formattedDate = DateFormat("dd, MMM yyyy, HH:mm a").format(parsedDate);

      return formattedDate;
    } catch (e) {

      return dateTime;
    }
  }
  static String getDateFormat(String dateTime) {
    if (dateTime.isEmpty) {
      return "N/A";
    }
    // Parse the input date
    DateTime parsedDate = DateFormat("dd-MMM-yy HH:mm:ss").parse(dateTime);
    // Format the date as "17, Jan 2025"
    String formattedDate = DateFormat("dd, MMM yyyy, HH:mm a").format(parsedDate);
    return formattedDate;
  }

  static String getDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return "N/A";
    }

    try {
      DateTime parsedDate = DateTime.parse(dateTime);

      return DateFormat("MMM dd, yyyy").format(parsedDate);
    } catch (e) {
      return "N/A";
    }
  }
  static const List<String> _canAddBookRoles = ["librarian", "owner", "superadmin","admin"];
  static bool canAddBookFromUserData(Data? userData) {
    final role = userData?.user?.role;
    return role != null && _canAddBookRoles.contains(role);
  }
}

