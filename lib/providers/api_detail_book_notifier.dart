import 'package:flutter_base/models/response/borrowed_book_response/UserAssign.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/dao/favorite_book_dao.dart';
import '../models/response/server_response.dart';
import '../utils/api_state_model.dart';
import '../../models/response/book_response/Book.dart' as ApiBook;
import '../utils/exceptions.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiDetailBookNotifierProvider =
StateNotifierProvider.autoDispose<ApiDetailBookNotifier, ApiStatesModel>(
        (ref) => ApiDetailBookNotifier(ref),
    name: "apiDetailBookNotifierProvider");
//TODO:: favorite book list
final favoriteBookDaoProvider = Provider<FavoriteBookDao>((ref) {
  final db = ref.watch(databaseProvider);
  return FavoriteBookDao(db);
});
//TODO:: favorite book added form db
final rawFavoriteBooksProvider = FutureProvider<List<ApiBook.Book>>((ref) async {
  final dao = ref.read(favoriteBookDaoProvider);

  final userId = (await Utils.getUserData())?.user?.id;
  if (userId == null) return [];
  return dao.getAllData(userId);

});
//TODO:: search book
final searchProvider = StateProvider.autoDispose<String>((ref) => "");
final favoriteBooksProvider = Provider<List<ApiBook.Book>>((ref) {
  final allBooksAsync = ref.watch(rawFavoriteBooksProvider);
  final query = ref.watch(searchProvider).toLowerCase().trim();

  return allBooksAsync.maybeWhen(
    data: (books) {
      if (query.isEmpty) return books;
      return books.where((book) =>
          (book.title ?? "").toLowerCase().contains(query)
      ).toList();
    },
    orElse: () => [],
  );
});
final userAssignedProvider = StateProvider<List<UserAssign>>((ref) => []);
//TODO:: selected user assign
var selectedTypeOfUserAssigned = StateProvider((ref) =>UserAssign());
class ApiDetailBookNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiDetailBookNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
  //TODO::Fetching Users AssignBooks
  Future<void> fetchUserAssignBooks() async {
    try {
      state = ApiStatesModel(
        States.LOADING, "Fetching user Assign ...", null,
      );

      final List<UserAssign> userAssign =
      await _ref.read(authRepository).getAllUserAssign();

      if (userAssign.isNotEmpty) {
        _ref.read(userAssignedProvider.notifier).state = userAssign;

        state = ApiStatesModel(States.DATA, "User Assign  fetched", userAssign,
        );
      } else {
        _ref.read(userAssignedProvider.notifier).state = [];

        state = ApiStatesModel(States.ERROR, "No User assign  found",
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
//TODO:: borrow book
  Future<void> borrowBook({
    required int bookId,
    required int userId,
    required DateTime issueDate,
    required DateTime dueDate,
    String? notes,
  }) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);

      final response = await _ref.read(authRepository).requestBorrowBook(
        bookId: bookId,
        userId: userId,
        issueDate: issueDate,
        dueDate: dueDate,
        notes: notes,
      );
      Utils.printInDebug("apiJson: ${response.toJson()}");

      state = ApiStatesModel(States.DATA, response.message!, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
}
