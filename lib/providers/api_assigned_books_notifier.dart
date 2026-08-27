
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

final apiAssignedBooksNotifierProvider =
    StateNotifierProvider.autoDispose<ApiAssignedBookNotifier, ApiStatesModel>(
        (ref) => ApiAssignedBookNotifier(ref),
        name: "apiAssignedBooksNotifierProvider");
//TODO::  list of borrow book
final bookBorrowedProvider = StateProvider<List<BorrowedBook>>((ref) => []);
//TODO:: list of user assign
final userAssignedProvider = StateProvider<List<UserAssign>>((ref) => []);
//TODO::form submitted provider
final isFormSubmittedProvider= StateProvider((ref) => false);

class ApiAssignedBookNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiAssignedBookNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));

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

  //TODO::Fetching libraries
  Future<void> fetchBorrowBooks() async {
    try {
      state = ApiStatesModel(States.LOADING, "Fetching Borrow Books...", null);

      final response = await _ref.read(authRepository).getBorrowBooks();
      final List<BorrowedBook> books = response.data ?? [];
      // if (response.data != null && (response.data as List).isNotEmpty) {
      //   // Save libraries in separate provider
      //   _ref.read(bookBorrowedProvider.notifier).state = response.data as List<BorrowedBook>;
      if (books.isNotEmpty) {
        _ref.read(bookBorrowedProvider.notifier).state = books;
        state = ApiStatesModel(States.DATA, "borrowed books fetched", response.data);
      } else {
        state = ApiStatesModel(States.ERROR, "No borrowed books found", null);
        _ref.read(bookBorrowedProvider.notifier).state = []; // clear provider
      }
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
      _ref.read(bookBorrowedProvider.notifier).state = []; // clear provider
    }
  }
  //TODO:: book return api
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
