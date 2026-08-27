import 'dart:io';

import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/request/login/LoginRequestModel.dart';

import 'package:flutter_base/models/response/login_response/LoginResponse.dart';


import 'package:flutter_base/models/states.dart';

import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../utils/api_state_model.dart';
import '../utils/strings.dart';

final apiAuthNotifierProvider =
StateNotifierProvider.autoDispose<ApiAuthNotifier, ApiStatesModel>(
        (ref) => ApiAuthNotifier(ref),
    name: "apiAuthNotifierProvider");
//TODO:: email provider for login user
final emailLoginProvider = StateProvider((ref) => "");
//TODO:: password provider for login user
final passwordLoginProvider = StateProvider((ref) => "");
class ApiAuthNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiAuthNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));

  //TODO:: api login
  Future<void> apiLogin(LoginRequestModel registerRequestModel) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      final response = await _ref.read(authRepository).apiLogin(registerRequestModel);
      state = ApiStatesModel(
        States.DATA,
        response.message ?? "Login successful",
        response,
      );
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
//TODO :: Forgot password api
  Future<void> apiForgotPassword(LoginRequestModel registerRequestModel) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      final response = await _ref.read(authRepository).apiForgotPassword(registerRequestModel);
      state = ApiStatesModel(
        States.DATA,
        response.message ?? "password reset successful",
        response,
      );
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }

}
