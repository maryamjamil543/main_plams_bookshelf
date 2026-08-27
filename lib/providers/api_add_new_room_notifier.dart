import 'package:flutter_base/models/request/room_create/NewRoomCreateRequest.dart';
import 'package:flutter_base/models/response/login_response/LibraryLogin.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/server_response.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiCreateRoomNotifierProvider =
StateNotifierProvider.autoDispose<ApiCreateRoomNotifier, ApiStatesModel>(
        (ref) => ApiCreateRoomNotifier(ref), name: "apiCreateRoomNotifierProvider");

//TODO :: selected library for the Add Room form
var selectedTypeOfLibraryRoom = StateProvider((ref) => LibraryLogin());

//TODO :: library list for the Add Room dropdown
var typeOfLibraryListRoomStateProvider =
StateProvider<List<LibraryLogin>>((ref) => []);

class ApiCreateRoomNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;
  ApiCreateRoomNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));

  Future<void> apiCreateRoom(CreateRoomRequestModel requestModel) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response = await _ref.read(authRepository).apiCreateRoom(requestModel);
      Utils.printInDebug("apiJson: ${response.toJson()}");
      state = ApiStatesModel(States.DATA, response.message!, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
}
