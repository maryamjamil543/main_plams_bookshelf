import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_base/models/response/server_response.dart';
import 'constants.dart';
import 'package:dio/dio.dart';

import 'constants.dart';

class DataException implements Exception {
  DataException({required this.message, this.statusCode});

  DataException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = Constants.errorRequestCancelled;
        break;
      case DioErrorType.connectTimeout:
        message = Constants.errorConnectionTimeout;
        break;
      case DioErrorType.receiveTimeout:
        message = Constants.errorReceiveTimeout;
        break;
      case DioErrorType.response:
        statusCode = dioError.response!.statusCode;
        if(dioError.response!.data is Map<String, dynamic>){
          message = _handleError(
              dioError.response!.statusCode!, dioError.response!.statusMessage!, ServerResponse.fromJson(dioError.response!.data), dioError.response?.data);
        } else{
          message = _handleError(
              dioError.response!.statusCode!, dioError.response!.statusMessage!,  ServerResponse(), null);
        }

        break;
      case DioErrorType.sendTimeout:
        message = Constants.errorSendTimeout;
        break;
      default:
        message = Constants.errorSomethingWentWrong;
        break;
    }
  }

  String message = "";
  int? statusCode;

  String _handleError(int statusCode, String message, ServerResponse responseData, dynamic response) {
    String? error;
    if(responseData.error != null){
      List<dynamic>? rawErrors = responseData.error?.cast<String>() as List<dynamic>?;
      if (rawErrors != null){
        List<String>? errors = rawErrors.map((e) => e.toString()).toList();
        for (var value in errors) {
          if (value.isNotEmpty) {
            print(value);
            error = value;
           // break; // Stop after the first error
          }
        }
      }

    } else{
      error = responseData.message;
    }
    switch (statusCode) {
      case 400:
        return error?? Constants.errorBadRequest;
      case 403:
        return error?? message;
      case 401:
        return error?? message;
      case 404:
        return error?? Constants.errorRequestNotFound;
      case 422:
        return error?? message;
      case 500:
        return error?? Constants.errorInternalServer;
      default:
        return error?? Constants.errorSomethingWentWrong;
    }
  }

  @override
  String toString() => message;
}

/*class DataException implements Exception {
  DataException({required this.message});

  DataException.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = Constants.errorRequestCancelled;
        break;
      case DioErrorType.connectTimeout:
        message = Constants.errorConnectionTimeout;
        break;
      case DioErrorType.receiveTimeout:
        message = Constants.errorReceiveTimeout;
        break;
      case DioErrorType.response:
        message = _handleError(
          dioError.response!.statusCode!,
          dioError.response!.data,
        );
        break;
      case DioErrorType.sendTimeout:
        message = Constants.errorSendTimeout;
        break;
      default:
        message = Constants.errorInternetConnection;
        break;
    }
  }

  String message = "";

  String _handleError(int statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return Constants.errorBadRequest;
      case 403:
        return data['message'] ?? Constants.errorSomethingWentWrong;
      case 401:
        return data['message'] ?? Constants.errorSomethingWentWrong;
      case 422:
        return data['message'] ?? Constants.errorSomethingWentWrong;
      case 404:
        return Constants.errorRequestNotFound;
      case 500:
        return Constants.errorInternalServer;
      default:
        return Constants.errorSomethingWentWrong;
    }
  }

  @override
  String toString() => message;
}*/
