
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/borrowed_book_response/BorrowedBook.dart';
import '../models/response/borrowed_book_response/UserAssign.dart';
import '../models/response/login_response/PaymentMethod.dart';
import '../models/response/server_response.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiUserAssignedBooksNotifierProvider =
    StateNotifierProvider.autoDispose<ApiUserAssignedBookNotifier, ApiStatesModel>(
        (ref) => ApiUserAssignedBookNotifier(ref),
        name: "apiUserAssignedBooksNotifierProvider");
//TODO :: borrow book provider api call
final bookBorrowedProvider = StateProvider<List<BorrowedBook>>((ref) => []);
//TODO :: user showing assign books  api provider
final userAssignedProvider = StateProvider<List<UserAssign>>((ref) => []);
//TODO :: form submitted provider
final isFormSubmittedProvider= StateProvider((ref) => false);

class ApiUserAssignedBookNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiUserAssignedBookNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));

  //TODO::Fetching Users AssignBooks
  Future<void> fetchUserAssignBooks() async {
    try {
      state = ApiStatesModel(
        States.LOADING,
        "Fetching User Assigned Books...",
        null,
      );

      final response = await _ref.read(authRepository).getAllUserAssign();
      final List<UserAssign> assigns = response ?? [];

      if (assigns.isNotEmpty) {
        _ref.read(userAssignedProvider.notifier).state = assigns;

        state = ApiStatesModel(
          States.DATA,
          "User assigned books fetched",
          assigns,
        );
      } else {
        _ref.read(userAssignedProvider.notifier).state = [];

        state = ApiStatesModel(
          States.ERROR,
          "No user assigned books found",
          null,
        );
      }
    } on DataException catch (error) {
      _ref.read(userAssignedProvider.notifier).state = [];

      state = ApiStatesModel(
        States.ERROR,
        error.message,
        null,
      );
    }
  }
  //TODO::Book Return Api
  Future<void> bookReturn(int bookId) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response =
      await _ref.read(authRepository).getReturnBook(bookId);
      Utils.printInDebug("apiJson: ${response.toJson()}");
      state = ApiStatesModel(States.DATA, response.message!, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
}
