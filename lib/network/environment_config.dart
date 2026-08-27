import 'package:flutter/foundation.dart';
import 'package:flutter_base/env/env.dart';

class EnvironmentConfig {
  static const IS_LIVE = true;
  static final BASE_API_URL_DEV = String.fromEnvironment('BASE_API_URL_DEV',
      defaultValue: Env.base_api_url_dev);
  static final BASE_API_URL_LIVE = String.fromEnvironment('BASE_API_URL_LIVE',
      defaultValue: Env.base_api_url_live);
  static final BASE_API_URL_LIVE_API_KEY = String.fromEnvironment('BASE_API_URL_LIVE_API_KEY',
      defaultValue: Env.base_api_url_live_api_key);
  static final GOOGLE_BOOK_API_URL = String.fromEnvironment('GOOGLE_BOOK_API_URL',
      defaultValue: Env.google_book_api_url);
  static final API_KEY = String.fromEnvironment('HEADER_API_KEY',
      defaultValue: Env.api_key);
  static final API_KEY_LIVE = String.fromEnvironment('X-API-KEY',
      defaultValue: Env.api_key_live);
  static final APP_KEY = String.fromEnvironment('HEADER_APP_KEY',
      defaultValue: Env.app_key);
  static final APP_KEY_LIVE = String.fromEnvironment('HEADER_APP_KEY',
      defaultValue: Env.app_key_live);

  // Common Api's Endpoints
  static const LOGIN = "/auth/login";
  static const FORGOT_PASSWORD = "/auth/forgot-password";
  static const REGISTER = "/auth/register";
  static const CREATE_EVENT = "/events";
  static const LIBRARIES = "/libraries";
  static const BORROWED_BOOKS = "/books/borrowed";
  static const Subscription_Package = "/subscription-packages";
  static const MANAGEMENT_ASSIGMNETS = "/books/manage-assignments";
  static const PAYMNET_METHODS = "/payment-methods";
  static const SUBSCRIPTIONS = "/subscriptions";
  static const BOOKS_BORROW = "/books/assign";
  static const SUBSCRIBE_DETAIl = "/subscribe";
  static const Books = "/books";
  static const events = "/events";
  static const SUBMIT_INDUSTRY_FORM = "enforcement/enforcement-industrial-unit";
  static const STUDENTS_ADD = "students-add";
  static const WATER_POLLUTION = "enforcement/water-pollution-data";
  static const AIR_POLLUTION = "water-pollution";
  static const SUBMIT_BRICK_KILN_FORM = "enforcement/brick-kilns-unit";
  static const SUBMIT_POLYTHENE_BAGS_FORM = "enforcement/polythene-bags-data";
  static const SUBMIT_ANTI_DENGUE_FORM = "enforcement/anti-dengue-data";
  static const SUBMIT_VEHICLE_POLLUTION_FORM = "enforcement/vehicle-pollution-data";
  static const SUBMIT_DESEALING_DATA = "enforcement/desealing-data";
  static const GET_DISTRICT_TEHSILS = "get-district-tehsil";
  static const SIGN_UP = "register";
  static const SYNC = "auth/base-data";
  static const EVENT_REGISTER = "events";
  static const GET_SURVEY_LISTINGS = "enforcement/activityAgainstUser";
  static const GET_FORM_LISTINGS = "enforcement/activities-against-districts";
  static const EVENTS = "events";
  static const ATTENDANCE = "attendance";
  static const VERIFY_OTP = "verifyotp";
  static const CREATE_ROOM = "/rooms";
  static const CREATE_SHELF = "/shelves";


  static String userToken = '';
  static getBaseUrl() {
    if (IS_LIVE) {
      return BASE_API_URL_DEV;
    } else {
      return BASE_API_URL_LIVE;
    }
  }

  static setUserToken(String value) {
    userToken = value;
  }
}
