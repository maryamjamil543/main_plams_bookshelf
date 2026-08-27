import 'dart:convert';
import 'package:flutter_base/models/request/book_create/NewBookCreateRequest.dart';
import 'package:flutter_base/models/response/book_response/Author.dart';
import 'package:flutter_base/models/response/book_response/Self.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/network/environment_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/response/book/GoogleBook.dart';
import '../models/response/login_response/Author.dart';
import '../models/response/login_response/Category.dart';
import '../models/response/login_response/Country.dart';
import '../models/response/login_response/Donor.dart';
import '../models/response/login_response/LibraryLogin.dart';
import '../models/response/login_response/Room.dart';
import '../models/response/server_response.dart';
import '../repository/auth_repository.dart';
import '../utils/api_state_model.dart';
import '../utils/exceptions.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';
final apiAddNewBookNotifierProvider =
StateNotifierProvider.autoDispose<ApiAddNewBookdNotifier, ApiStatesModel>(
        (ref) => ApiAddNewBookdNotifier(ref),
    name: "apiAddNewBookNotifierProvider");

final isFormSubmittedProvider = StateProvider((ref) => false);
//TODO:: Library Listing
var selectedTypeOfLibrary = StateProvider((ref) =>LibraryLogin());
var typeOfLibraryListStateProvider = StateProvider<List<LibraryLogin>>((ref) => []);

final countryListProvider = StateProvider<List<Country>>((ref) => []);
final selectedCountryProvider = StateProvider<Country?>((ref) => null);

final cityListProvider = StateProvider<List<String>>((ref) => []);
final selectedCityProvider = StateProvider<String?>((ref) => null);
//TODO:: Author Listing
var selectedTypeOfAuthor = StateProvider((ref) =>AuthorBaseData());
var typeOfAuthorListStateProvider = StateProvider<List<AuthorBaseData>>((ref) => []);
//TODO:: Shelf Listing
var selectedTypeOfShelf = StateProvider((ref) =>Shelf());
var typeOfShelfListStateProvider = StateProvider<List<Shelf>>((ref) => []);
//TODO:: ROOM Listing
var selectedTypeOfRoom = StateProvider((ref) =>Room());
var typeOfRoomListStateProvider = StateProvider<List<Room>>((ref) => []);
//TODO:: Donor Listing
var selectedTypeOfDonor = StateProvider((ref) =>Donor());
var typeOfDonorListStateProvider = StateProvider<List<Donor>>((ref) => []);
//TODO:: Category Data
var selectedTypeOfCategory = StateProvider((ref) =>Category());
var typeOfCategoryListStateProvider = StateProvider<List<Category>>((ref) => []);

//TODO :: Checkbox
var isDonatedCbProvider = StateProvider((ref)=> false);
var isDonatedValueCbProvider = StateProvider((ref)=> 0);
class ApiAddNewBookdNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;
  AsyncValue<List<GoogleBook>> bookSearchState = const AsyncValue.data([]);

  ApiAddNewBookdNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
  //TODO :: Create book api
  Future<void> apiSubmitCreateBookForm(
      String bookTitle,
      String isbNumber,
      String edition,
      String publisherName,
      String publisherDate,
      int price,
      int copies,
      String summary,
      String donorName,
      String donorEmail,
      String donorPhone,
      String newCategory,
      String newAuthorName,
      // String  previewLink,
      // String pdfLink,
      // {bool isFromGoogleBook = false}
      ) async {
    var apiRequest = NewBookCreateRequestModel(
        title: bookTitle,
        edition: edition,
        publishDate: publisherDate,
        price: price,
         copies: copies,
        description: summary,
      publishName: publisherName,
      donorEmail: donorEmail,
      donorName: donorName,
      donorPhone: donorPhone,
      isbn: isbNumber, isDontedCheckBox: _ref.watch(isDonatedValueCbProvider),
      authorId: _ref.read(selectedTypeOfAuthor)?.id.toString() ?? '',
      libraryId: _ref.read(selectedTypeOfLibrary)?.id.toString() ?? '',
      // donorId: _ref.read(selectedTypeOfDonor)?.id.toString() ?? '',
        donorId: _ref.read(selectedTypeOfDonor)?.id?.toString(),
      // donorId: (_ref.read(selectedTypeOfDonor)?.id ?? 0).toString(),
      categoryId: _ref.read(selectedTypeOfCategory)?.id.toString() ?? '',
      shelfId: _ref.read(selectedTypeOfShelf)?.id.toString() ?? '',
      newAuthorName: newAuthorName,
      newCategoryName: newCategory,
      // isFromGoogle: isFromGoogleBook,
      // pdfDownloadLink: pdfLink,
      // previewLink: previewLink,


    );

    Utils.printInDebug("apiJson: ${apiRequest.toJson()}");
    await submitNewBookCreateForm(apiRequest);
  }
  //TODO:: Submit api
  Future<void> submitNewBookCreateForm(NewBookCreateRequestModel requestModel) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response =
      await _ref.read(authRepository).apiSubmitNewBookCreateForm(requestModel);
      state = ApiStatesModel(States.DATA, response.message!, response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
  //TODO :: Get all authors
  Future<void> getAllAuthors() async {
    try {
      // state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      List<AuthorBaseData> dataList =
      await _ref.read(authRepository).getAllAuthors();
      // state = ApiStatesModel(States.DATA, "Record found", dataList);
      _ref
          .read(typeOfAuthorListStateProvider.notifier)
          .state = dataList;
    }
    on DataException catch (error) {
      // state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
  //TODO :: Get all Categories
  Future<void> getAllCatogies() async {
    List<Category> dataList =
    await _ref.read(authRepository).getAllCategory();
    _ref.read(typeOfCategoryListStateProvider.notifier).state = dataList;
  }
  //TODO :: Get all Categories
  Future<void> getAllRoom() async {
    List<Room> dataList =
    await _ref.read(authRepository).getAllRooms();
    _ref.read(typeOfRoomListStateProvider.notifier).state = dataList;
  }
  //TODO :: Get all Categories
  Future<void> getAllDonor() async {
    List<Donor> dataList =
    await _ref.read(authRepository).getAllDonor();
    _ref.read(typeOfDonorListStateProvider.notifier).state = dataList;
  }
  //TODO :: Get all Categories
  Future<void> getAllShelf() async {
    List<Shelf> dataList =
    await _ref.read(authRepository).getAllShelf();
    _ref.read(typeOfShelfListStateProvider.notifier).state = dataList;
  }

}
final bookSearchProvider = StateNotifierProvider<BookSearchNotifier, AsyncValue<List<GoogleBook>>>(
      (ref) => BookSearchNotifier(),
);
//TODO :: book search notifier
class BookSearchNotifier extends StateNotifier<AsyncValue<List<GoogleBook>>> {
  BookSearchNotifier() : super(const AsyncValue.data([]));

  static  String _apiKey = EnvironmentConfig.BASE_API_URL_LIVE_API_KEY;
  static  String _base_url = EnvironmentConfig.GOOGLE_BOOK_API_URL;
  String _lastQuery = "";
  //TODO :: Get Search book Api
  Future<void> searchBooks(String query) async {
    final trimmed = query.trim();

    if (trimmed.length < 3) {
      state = const AsyncValue.data([]);
      return;
    }
    if (_lastQuery == trimmed) return;
    _lastQuery = trimmed;

    state = const AsyncValue.loading();

    try {
      final url =
          '$_base_url'
          '?q=${Uri.encodeComponent(trimmed)}'
          '&maxResults=20'
          '&printType=books'
          '&key=$_apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List? ?? [];
        final books = items.map((e) => GoogleBook.fromJson(e)).toList();

        state = AsyncValue.data(books);
      }
      else if (response.statusCode == 429) {
        state = AsyncValue.error(
          "Too many requests. Please wait and try again.",
          StackTrace.current,
        );
      }
      else {
        state = AsyncValue.error(
          "Error: ${response.statusCode}",
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
  //TODO :: Get clear query
  void clear() {
    _lastQuery = "";
    state = const AsyncValue.data([]);
  }
}