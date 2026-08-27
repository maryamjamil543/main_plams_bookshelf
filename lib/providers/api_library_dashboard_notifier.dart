
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/login_response/PaymentMethod.dart';
import '../utils/api_state_model.dart';

final apiLibraryDashboardNotifierProvider =
StateNotifierProvider.autoDispose<ApiLibraryDashboardNotifier, ApiStatesModel>(
        (ref) => ApiLibraryDashboardNotifier(ref),
    name: "apiLibraryDashboardNotifierProvider");
//TODO:: select  library
final selectedLibraryProvider = StateProvider<Library?>((ref) => null);
//TODO:: list of library
final librariesProvider = StateProvider<List<Library>>((ref) => []);
//TODO:: list of books
final booksListProvider = StateProvider<List<Book>>((ref) => []);

class ApiLibraryDashboardNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiLibraryDashboardNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
  //TODO::Fetching libraries
  Future<void> fetchLibraries() async {
    try {
      state = ApiStatesModel(States.LOADING, "Fetching libraries...", null);

      final response = await _ref.read(authRepository).getLibraries();

      if (response.data != null && (response.data as List).isNotEmpty) {
        // Save libraries in separate provider
        _ref.read(librariesProvider.notifier).state = response.data as List<Library>;

        state = ApiStatesModel(States.DATA, "Libraries fetched", response.data);
      } else {
        state = ApiStatesModel(States.ERROR, "No libraries found", null);
        _ref.read(librariesProvider.notifier).state = []; // clear provider
      }
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
      _ref.read(librariesProvider.notifier).state = []; // clear provider
    }
  }
//TODO::Fetching Books against select Library
  Future<void> fetchBooksByLibrary(int libraryId) async {
    try {
      state = ApiStatesModel(States.LOADING, "Fetching books...", null);

      final response = await _ref.read(authRepository).getBooksByLibrary(libraryId);

      if (response.data.isNotEmpty) {
        List<Book> books = response.data;

        state = ApiStatesModel(States.DATA, "Books fetched", books);

        _ref.read(booksListProvider.notifier).state = books;
      } else {
        state = ApiStatesModel(States.ERROR, "No books found", null);
      }
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }

}
