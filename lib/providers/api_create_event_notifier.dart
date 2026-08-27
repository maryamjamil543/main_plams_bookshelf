
import 'package:flutter_base/models/request/event_register/CreateEventRequest.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_base/views/book_event/create_event_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/request/register/RegisterRequestModel.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/borrowed_book_response/BorrowedBook.dart';
import '../models/response/borrowed_book_response/UserAssign.dart';
import '../models/response/login_response/LibraryLogin.dart';
import '../models/response/login_response/PaymentMethod.dart';
import '../models/response/server_response.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiCreateEventNotifierProvider =
    StateNotifierProvider.autoDispose<ApiCreateEventNotifier, ApiStatesModel>(
        (ref) => ApiCreateEventNotifier(ref),
        name: "apiCreateEventNotifierProvider");
//TODO:: select payment method
var selectedTypeOfPaymentMethod = StateProvider((ref) =>PaymentMethod());
//TODO:: list of payment method
var typeOfPaymentListStateProvider = StateProvider<List<PaymentMethod>>((ref) => []);
//TODO:: list of borrow books
final bookBorrowedProvider = StateProvider<List<BorrowedBook>>((ref) => []);
//TODO:: user assign list
final userAssignedProvider = StateProvider<List<UserAssign>>((ref) => []);
//TODO:: form submitted provider
final isFormSubmittedProvider= StateProvider((ref) => false);
//TODO:: Library Listing
var selectedTypeOfLibrary = StateProvider((ref) =>LibraryLogin());
var typeOfLibraryListStateProvider = StateProvider<List<LibraryLogin>>((ref) => []);
class ApiCreateEventNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiCreateEventNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
  //TODO::Fetching Users PaymentMethods
  Future<void> getAllPaymentMethod() async {
    List<PaymentMethod> dataList =
    await _ref.read(authRepository).getAllPaymentMethod();
    _ref.read(typeOfPaymentListStateProvider.notifier).state = dataList;
  }
  //TODO:: create Event

  Future<void> apiCreateEvent(CreateEventRequestModel requestModel) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response =
      await _ref.read(authRepository).apiCreateEvent(requestModel);
      Utils.printInDebug("apiJson: ${response.toJson()}");
      state = ApiStatesModel(States.DATA, response.message!, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
}

