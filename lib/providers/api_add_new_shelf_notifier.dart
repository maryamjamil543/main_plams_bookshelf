import 'package:flutter_base/models/request/shelf_create/NewShelfCreateRequest.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/response/server_response.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiCreateShelfNotifierProvider =
StateNotifierProvider.autoDispose<ApiCreateShelfNotifier, ApiStatesModel>(
      (ref) => ApiCreateShelfNotifier(ref),
  name: "apiCreateShelfNotifierProvider",
);

class ApiCreateShelfNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiCreateShelfNotifier(this._ref)
      : super(ApiStatesModel(States.IDLE, "", null));

  Future<void> apiCreateShelf(
      CreateShelfRequestModel requestModel) async {
    try {
      state = ApiStatesModel(
        States.LOADING,
        pleaseWaitSignIn,
        null,
      );

      ServerResponse response =
      await _ref.read(authRepository).apiCreateShelf(requestModel);

      Utils.printInDebug("apiJson: ${response.toJson()}");

      state = ApiStatesModel(
        States.DATA,
        response.message!,
        response,
      );
    } on DataException catch (error) {
      state = ApiStatesModel(
        States.ERROR,
        error.message,
        null,
      );
    }
  }
}