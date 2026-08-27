import 'dart:convert';
import 'dart:io';
import 'package:flutter_base/models/response/login_response/base_data_response.dart';
import 'package:flutter_base/network/environment_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/book/GoogleBook.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/login_response/User.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiDashboardNotifierProvider =
    StateNotifierProvider.autoDispose<ApiDashboardNotifier, ApiStatesModel>(
        (ref) => ApiDashboardNotifier(ref),
        name: "apiDashboardNotifierProvider");
//TODO:: user data information show provider
final userDataProvider = StateProvider<User?>((ref) => null);
//TODO:: selected library
final selectedLibraryProvider = StateProvider<Library?>((ref) => null);
//TODO:: list of libraries
final librariesProvider = StateProvider<List<Library>>((ref) => []);
//TODO:: list of books
final booksListProvider = StateProvider<List<Book>>((ref) => []);
//TODO:: list of google books
final googleBookListProvider = StateProvider<List<GoogleBook>>((ref) => []);
//TODO:: form submit provider
final isFormSubmittedProvider= StateProvider((ref) => false);

class ApiDashboardNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiDashboardNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
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
//TODO:: fetching books against assign library
  Future<void> fetchBooksByLibrary(int libraryId) async {
    try {
      state = ApiStatesModel(States.LOADING, "Fetching books...", null);

      final response =
      await _ref.read(authRepository).getBooksByLibrary(libraryId);

      if (response.data.isNotEmpty) {
        List<Book> books = response.data;

        for (var book in books) {
          book.isFromGoogle =
              (book.source == "google");
        }
        _ref.read(booksListProvider.notifier).state = books;

        state = ApiStatesModel(States.DATA, "Books fetched", books);
      } else {
        state = ApiStatesModel(States.ERROR, "No books found", null);
      }
    } catch (e) {
      state = ApiStatesModel(States.ERROR, e.toString(), null);
    }
  }
  //TODO::Fetching Books against the qr code or isbn number
  Future<GoogleBook?> fetchBookByIsbn(String rawIsbn) async {
    final isbn = rawIsbn.replaceAll(RegExp(r'[^0-9Xx]'), '');

    if (isbn.isEmpty || isbn.length < 10) {
      state = ApiStatesModel(States.ERROR, "Invalid ISBN", null);
      return null;
    }

    final hasInternet = await Utils.isInternetAvailable();
    if (!hasInternet) {
      state = ApiStatesModel(States.ERROR, "No internet connection", null);
      return null;
    }

    state = ApiStatesModel(States.LOADING, "Fetching book details...", null);

    try {
      final data = await _ref.read(authRepository).fetchByIsbn(isbn);

      if (data == null || data['totalItems'] == 0) {
        state = ApiStatesModel(States.ERROR, "No book found", null);
        return null;
      }

      final book = GoogleBook.fromJson(data['items'][0]);

      _ref.read(googleBookListProvider.notifier).state = [book];

      state = ApiStatesModel(States.DATA, "Success", book);
      return book;
    } catch (e) {
      state = ApiStatesModel(States.ERROR, e.toString(), null);
      return null;
    }
  }
  //TODO:: get sync data api
  Future<void> getApiSyncData(int libraryId) async {
    try {
      // Show loader
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);

      BaseDataResponse response = await _ref.read(authRepository).apiSyncData(libraryId);

      await _ref.read(authRepository).insertSyncData(response);

      String message = response.message ?? "Data loaded successfully";

      // Update state with data
      state = ApiStatesModel(States.DATA, message, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message ?? "Something went wrong", null);
    } catch (error) {
      state = ApiStatesModel(States.ERROR, error.toString(), null);
    }
  }
  //TODO:: clear all database data
  Future<void> clearDatabase() async {
    await _ref.read(authRepository).removeAllData();
  }
}
