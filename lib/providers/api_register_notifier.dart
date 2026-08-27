import 'dart:io';

import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/response/server_response.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../models/request/register/RegisterRequestModel.dart';
import '../models/response/login_response/Country.dart';
import '../models/response/login_response/LibraryLogin.dart';
import '../repository/auth_repository.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiRegisterNotifierProvider =
StateNotifierProvider.autoDispose<ApiRegisterNotifier, ApiStatesModel>(
        (ref) => ApiRegisterNotifier(ref),
    name: "apiRegisterNotifierProvider");
//TODO:: user email
final emailProvider = StateProvider((ref) => "");
//TODO:: user name
final nameProvider = StateProvider((ref) => "");
//TODO:: user password
final passwordRegisterProvider = StateProvider((ref) => "");
//TODO:: confrim password
final confrimPasswordRegisterProvider = StateProvider((ref) => "");
//TODO:: country list
final countryListProvider = StateProvider<List<Country>>((ref) => []);
//TODO:: select country
final selectedCountryProvider = StateProvider<Country?>((ref) => null);
//TODO:: selected country showing list of cities
final cityListProvider = StateProvider<List<String>>((ref) => []);
//TODO:: selected city
final selectedCityProvider = StateProvider<String?>((ref) => null);
class ApiRegisterNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiRegisterNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
  //TODO:: get all list of countries
  Future<void> getAllCountries() async {
    List<Country> dataList =
    await _ref.read(authRepository).getAllCountries();
    _ref.read(countryListProvider.notifier).state = dataList;
  }
  //TODO:: register user api
  Future<void> apiRegister(RegisterRequestModel requestModel) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response =
      await _ref.read(authRepository).apiRegister(requestModel);
      Utils.printInDebug("apiJson: ${response.toJson()}");
      state = ApiStatesModel(States.DATA, response.message!, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }

}
