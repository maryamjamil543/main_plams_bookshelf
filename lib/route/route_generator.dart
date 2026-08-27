import 'package:flutter/material.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/views/add_new_book/add_new_book_screen.dart';
import 'package:flutter_base/views/add_room/add_new_room.dart';
import 'package:flutter_base/views/add_shelf/add_new_shelf.dart';
import 'package:flutter_base/views/book_event/create_event_screen.dart';
import 'package:flutter_base/views/login/forgot_pasword_screen.dart';
import 'package:flutter_base/views/subscription_user/library_dashboard.dart';
import 'package:flutter_base/views/dashboard/dashboard.dart';
import 'package:flutter_base/views/detail_screen/detail_book_screen.dart';
import 'package:flutter_base/views/login/login_screen.dart';
import 'package:flutter_base/views/signup/signup_screen.dart';
import 'package:flutter_base/views/splash/splash_screen.dart';
import 'package:flutter_base/views/subscription/Subscription.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/login_response/PlatformPackage.dart';
import '../views/book_event/event_screen.dart';
import '../views/subscription_user/suscription_detail_screen.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final dynamic args = settings.arguments;

    switch (settings.name) {
      case Routes.LOGIN:
        return MaterialPageRoute<dynamic>(builder: (_) => const LoginScreen());
      case Routes.FORGOT_SCREEN:
        return MaterialPageRoute<dynamic>(builder: (_) => const ForgotPasswordScreen());

      case Routes.SPLASH:
        return MaterialPageRoute<dynamic>(builder: (_) => const SplashScreen());
      case Routes.DASHBOARD:
        return MaterialPageRoute<dynamic>(builder: (_) => DashboardScreen());
      case Routes.CREATE_EVENT_SCREEN:
        return MaterialPageRoute<dynamic>(builder: (_) => CreateEventScreen());
      // case Routes.STUDENT_SCREEN_FORM:
      //   return MaterialPageRoute<dynamic>(
      //       builder: (_) => const StudentFormScreen());
      case Routes.REGISTER:
        return MaterialPageRoute<dynamic>(builder: (_) => const SignUpScreen());
      // case Routes.POLYTENE_BAGS_SCREEN:
      //   return MaterialPageRoute<dynamic>(builder: (_) => const PolytheneBagsScreen());
      // case Routes.DETAIL_SCREEN:
      //   return MaterialPageRoute<dynamic>(
      //       builder: (_) => const DetailBookScreen());
      case Routes.DETAIL_SCREEN:
        if (args is Book) {
          return MaterialPageRoute<dynamic>(
            builder: (_) => DetailBookScreen(bookJson: args),
          );
        } else {
          return _errorRoute();
        }
      // case Routes.SUBSCRIPTION_SCREEN:
      //   return MaterialPageRoute<dynamic>(
      //       builder: (_) => const SubscriptionScreen());
      case Routes.SUBSCRIPTION_SCREEN:
        if (args is Library) {
          return MaterialPageRoute<dynamic>(
            builder: (_) => SubscriptionScreen(args),
          );
        } else {
          return _errorRoute();
        }
      case Routes.SUBSCRIPTION_DETAIL_SCREEN:
        if (args is Map<String, dynamic>) {
          final library = args['library'] as Library?;
          final selectedPackage = args['package'] as PlatformPackage?;
          return MaterialPageRoute<dynamic>(
            builder: (_) => SuscriptionDetailScreen(
              libraryJson: library,
              preSelectedPackage: selectedPackage,
            ),
          );
        } else {
          return _errorRoute();
        }
      case Routes.ADD_NEW_BOOK_SCREEN:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const AddNewBookScreen());
      case Routes.LIBRARY_DASHBOARD_SCREEN:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const LibraryDashboardScreen());
      case Routes.BOOK_EVENT:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const EventScreen());
      case Routes.ADD_ROOM_SCREEN:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const AddRoomScreen());
      case Routes.ADD_ROOM_SCREEN:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const AddShelfScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
