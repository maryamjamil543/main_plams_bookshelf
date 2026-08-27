import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_base/database/my_database.dart';
import 'package:flutter_base/models/request/book_create/NewBookCreateRequest.dart';
import 'package:flutter_base/models/request/event_register/EventRegisterRequest.dart';
import 'package:flutter_base/models/request/login/LoginRequestModel.dart';
import 'package:flutter_base/models/request/subscription_detail/SubscriptionDetailRequestModel.dart';
import 'package:flutter_base/models/response/book_response/Author.dart';
import 'package:flutter_base/models/response/book_response/BookResponse.dart';
import 'package:flutter_base/models/response/book_response/Self.dart';
import 'package:flutter_base/models/response/borrowed_book_response/GetBorrowedBookResponse.dart';
import 'package:flutter_base/models/response/get_library_response/GetLibraryResponse.dart';
import 'package:flutter_base/models/response/login_response/Author.dart';
import 'package:flutter_base/models/response/login_response/Category.dart';
import 'package:flutter_base/models/response/login_response/Country.dart';
import 'package:flutter_base/models/response/login_response/Donor.dart';
import 'package:flutter_base/models/response/login_response/LoginResponse.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import 'package:flutter_base/models/response/login_response/Room.dart';
import 'package:flutter_base/models/response/login_response/base_data_response.dart';
import 'package:flutter_base/models/response/subscription_plan/SubscriptionResponseModel.dart';
import 'package:flutter_base/network/environment_config.dart';
import 'package:flutter_base/repository/network_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request/event_register/CreateEventRequest.dart';
import '../models/request/register/RegisterRequestModel.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/borrowed_book_response/UserAssign.dart';
import '../models/response/event/Events.dart';
import '../models/response/login_response/PlatformPackage.dart';
import '../models/response/subscription_plan_response/GetSubscriptionPlanResponse.dart';
import '../models/response/server_response.dart';

final authRepository = StateProvider((ref) => _AuthRepository(ref));
final databaseProvider = StateProvider((ref) => MyDatabase());

class _AuthRepository {
  Ref ref;

  _AuthRepository(this.ref);
//TODO :: LOGIN
  Future<LoginResponse> apiLogin(LoginRequestModel loginRequest) async {
    try {
      Response response = await ref.read(networkRepositoryProvider).getRequest(
          (EnvironmentConfig.LOGIN), UrlSuffix.POST, false,
          data: await loginRequest.toJson());
      Map<String, dynamic> jsonData;
      if (response.data is String) {
        jsonData = json.decode(response.data);
      } else if (response.data is Map<String, dynamic>) {
        jsonData = response.data;
      } else {
        throw Exception("Unexpected response type: ${response.data.runtimeType}");
      }
      LoginResponse loginResponse = LoginResponse.fromJson(jsonData);
      if (loginResponse.data?.accessToken != null) {
          Utils.setUserData(loginResponse.data!);
          if (loginResponse.data!.libraries != null) {
            Utils.setLibrariesList(loginResponse.data!.libraries!);
          }
          // if (loginResponse.data!.platFormPackage != null) {
          //   Utils.setPlatformPackageList(loginResponse.data!.platFormPackage!);
          // }
          // if (loginResponse.data!.paymentMethods != null) {
          //   Utils.setPaymentMethodsList(loginResponse.data!.paymentMethods!);
          // }
          // if (loginResponse.data!.country != null) {
          //   Utils.setCountriesList(loginResponse.data!.country!);
          // }
          // if (loginResponse.data!.bookBaseData != null) {
          //   await Utils.saveBookLists(loginResponse.data!.bookBaseData!);
          // }
          Utils.setAccessToken(loginResponse.data!.accessToken!);
          Utils.setIsLoggedIn(true);
        }
      else {
        Utils.printInDebug("LOGIN FAILED OR TOKEN MISSING");
      }
      return loginResponse;
    } catch (error) {
      Utils.printInDebug("error: ${error}");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: Forgot Password
  Future<ServerResponse> apiForgotPassword(LoginRequestModel loginRequest) async {
    try {
      Response response = await ref.read(networkRepositoryProvider).getRequest(
          (EnvironmentConfig.FORGOT_PASSWORD), UrlSuffix.POST, false,
          data: await loginRequest.toJson());

      // Directly parse response into BaseDataResponse
      return ServerResponse.fromJson(response.data,code: response.statusCode);
    } catch (error) {
      Utils.printInDebug("error: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: Base Data through library id
  Future<BaseDataResponse> apiSyncData(int libraryId) async {
    try {
      Response response = await ref
          .read(networkRepositoryProvider)

          .getRequest("${EnvironmentConfig.SYNC}?library_id=$libraryId",UrlSuffix.GET, false);

      // Directly parse response into BaseDataResponse
      return BaseDataResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("error: $error");
      throw DataException(message: error.toString());
    }
  }
//TODO ::Direct Google Search using ibn number
  Future<dynamic> fetchByIsbn(String isbn) async {
    final apiKey = EnvironmentConfig.BASE_API_URL_LIVE_API_KEY;

    try {
      final uri = Uri.parse(EnvironmentConfig.GOOGLE_BOOK_API_URL).replace(
        queryParameters: {
          "q": "isbn:$isbn",
          if (apiKey.isNotEmpty) "key": apiKey,
        },
      );
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(uri.toString(), UrlSuffix.GET, false);

      return response.data;
    } catch (error) {
      throw DataException(message: error.toString());
    }
  }
  //TODO :: BaseData api
  Future<BaseDataResponse> apiSyncSplashData() async {
    try {
      Response response = await ref
          .read(networkRepositoryProvider)

          .getRequest(EnvironmentConfig.SYNC,UrlSuffix.GET, false);

      // Directly parse response into BaseDataResponse
      return BaseDataResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("error: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: create event register api
  Future<ServerResponse> apiEventRegister(EventRegisterRequest requestModel,int eventId) async {
    try {
      Response response = await ref
          .read(networkRepositoryProvider)
          .getRequest("${EnvironmentConfig.EVENT_REGISTER}/$eventId/register",UrlSuffix.POST, true,
        data: requestModel.toJson(),
        isMultipart: true,
          formData: await requestModel.toFormData());

      // Directly parse response into BaseDataResponse
      return ServerResponse.fromJson(response.data,code: response.statusCode);
    } catch (error) {
      Utils.printInDebug("error: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: REGISTER API
  Future<ServerResponse> apiRegister(
      RegisterRequestModel requestModel) async {
    try {
      Response response = await ref.read(networkRepositoryProvider).getRequest(
          (EnvironmentConfig.REGISTER), UrlSuffix.POST, false,
          data: requestModel.toJson(),
          isMultipart: false,
          formData: await requestModel.toFormData());
      ServerResponse serverResponse = ServerResponse.fromJson(response.data,code: response.statusCode);
      return serverResponse;
    } catch (error) {
      Utils.printInDebug("error: ${error}");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: Create Event Api
  Future<ServerResponse> apiCreateEvent(
      CreateEventRequestModel requestModel) async {
    try {
      Response response = await ref.read(networkRepositoryProvider).getRequest(
          (EnvironmentConfig.CREATE_EVENT), UrlSuffix.POST, true,
          data: requestModel.toJson(),
          isMultipart: false,
          formData: await requestModel.toFormData());
      ServerResponse serverResponse = ServerResponse.fromJson(response.data,code: response.statusCode);
      return serverResponse;
    } catch (error) {
      Utils.printInDebug("error: ${error}");
      throw DataException(message: error.toString());
    }
  }
  //TODO Get Subspcripton Api
  Future<GetSubscriptionResponse> getSubscpritonPlan() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(EnvironmentConfig.SUBSCRIPTIONS, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return GetSubscriptionResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("Error fetching subscriptionPlan: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO Get Libraries
  Future<GetLibrariesResponse> getLibraries() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(EnvironmentConfig.LIBRARIES, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return GetLibrariesResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("Error fetching libraries: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO Get BorrowBooks
  Future<GetBorrowedBookResponse> getBorrowBooks() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(EnvironmentConfig.BORROWED_BOOKS, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return GetBorrowedBookResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("Error fetching Borrowed books: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO ::Assign User fetch
  Future<List<UserAssign>> getAllUserAssign() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(
          EnvironmentConfig.MANAGEMENT_ASSIGMNETS, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }
      final List<UserAssign> events = (response.data as List)
          .map((e) => UserAssign.fromJson(e as Map<String, dynamic>))
          .toList();

      return events;
    } catch (error) {
      Utils.printInDebug("Error fetching user assignment: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO Get Books Return
  Future<ServerResponse> getReturnBook(int bookId) async {
    try {
      final endpoint = "${EnvironmentConfig.Books}/$bookId/return";
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(endpoint, UrlSuffix.POST, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return ServerResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("Error return book $bookId: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO Get Books Return
  Future<ServerResponse> requestBorrowBook({
    required int bookId,
    required int userId,
    required DateTime issueDate,
    required DateTime dueDate,
    String? notes,
  }) async {
    try {
      final endpoint = EnvironmentConfig.BOOKS_BORROW;

      final Map<String, dynamic> body = {
        "book_id": bookId,
        "user_id": userId,
        "issued_at": issueDate.toIso8601String(),
        "due_at": dueDate.toIso8601String(),
        "notes": notes ?? "",
      };
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(endpoint, UrlSuffix.POST, true,data:body);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return ServerResponse.fromJson(response.data, code: response.statusCode,);
    } catch (error) {
      Utils.printInDebug("Error return book $bookId: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO Get Events
  Future<List<Event>> getEvents() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(EnvironmentConfig.events, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      // Since backend returns direct List
      final List<Event> events = (response.data as List)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();

      return events;

    } catch (error) {
      Utils.printInDebug("Error fetching events: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: get all subscritpion
  Future<List<PlatformPackage>> getAllPlatfromPackage() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(EnvironmentConfig.Subscription_Package, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }
      final List<PlatformPackage> events = (response.data as List)
          .map((e) => PlatformPackage.fromJson(e as Map<String, dynamic>))
          .toList();

      return events;

    } catch (error) {
      Utils.printInDebug("Error fetching events: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: get all Payment
  Future<List<PaymentMethod>> getAllPaymentMethodsFromApi() async {
    try {
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(EnvironmentConfig.PAYMNET_METHODS, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }
      final List<PaymentMethod> events = (response.data as List)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList();

      return events;

    } catch (error) {
      Utils.printInDebug("Error fetching events: $error");
      throw DataException(message: error.toString());
    }
  }

  Future<SubscriptionResponseModel> getSubscriptionByLibrary(int libraryId) async {
    try {
      final endpoint = "${EnvironmentConfig.LIBRARIES}/$libraryId/plans";
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(endpoint, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return SubscriptionResponseModel.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("Error fetching books for library $libraryId: $error");
      throw DataException(message: error.toString());
    }
  }
//TODO Get Books Agasinst the library
  Future<BookResponse> getBooksByLibrary(int libraryId) async {
    try {
      final endpoint = "${EnvironmentConfig.LIBRARIES}/$libraryId/books";
      final response = await ref
          .read(networkRepositoryProvider)
          .getRequest(endpoint, UrlSuffix.GET, true);

      if (response.data == null) {
        throw DataException(message: "Empty response from server");
      }

      return BookResponse.fromJson(response.data);
    } catch (error) {
      Utils.printInDebug("Error fetching books for library $libraryId: $error");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: library subscribe api
  Future<ServerResponse> apiSubmitSubscriptionDetail(
      SubscriptionDetailRequestModel requestModel,int libraryId) async {
    try {
      Response response = await ref.read(networkRepositoryProvider).getRequest(

          ("${EnvironmentConfig.LIBRARIES}/$libraryId/subscribe"), UrlSuffix.POST, true,
          data: requestModel.toJson(),
          isMultipart: true,
          formData: await requestModel.toFormData());
      ServerResponse serverResponse = ServerResponse.fromJson(response.data);
      return serverResponse;
    } catch (error) {
      Utils.printInDebug("error: ${error}");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: new book create api
  Future<ServerResponse> apiSubmitNewBookCreateForm(
      NewBookCreateRequestModel requestModel) async {
    try {
      Response response = await ref.read(networkRepositoryProvider).getRequest(
          (EnvironmentConfig.Books), UrlSuffix.POST, true,
          data: requestModel.toJson(),
          isMultipart: true,
          formData: await requestModel.toFormData());
      ServerResponse serverResponse = ServerResponse.fromJson(response.data);
      return serverResponse;
    } catch (error) {
      Utils.printInDebug("error: ${error}");
      throw DataException(message: error.toString());
    }
  }
  //TODO :: Insert all data
  Future<void> insertSyncData(BaseDataResponse response) async {
    final syncData =response;
    final syncBookBaseData =response.bookBaseData;
    await ref.read(databaseProvider.notifier).state.countryDao.deleteAll();
    await ref
        .read(databaseProvider.notifier)
        .state
        .countryDao
        .insertAllData(syncData.countries);
    await ref.read(databaseProvider.notifier).state.platformPackageDao.deleteAll();
    await ref
        .read(databaseProvider.notifier)
        .state
        .platformPackageDao
        .insertAllData(syncData.platformPackages);
    await ref.read(databaseProvider.notifier).state.paymentMethodDao.deleteAll();
    await ref
        .read(databaseProvider.notifier)
        .state
        .paymentMethodDao
        .insertAllData(syncData.paymentMethods);
    if (syncBookBaseData != null) {
      await ref.read(databaseProvider.notifier).state.categoryDao.deleteAll();
      await ref
          .read(databaseProvider.notifier)
          .state
          .categoryDao
          .insertAllData(syncBookBaseData.categories);
      await ref.read(databaseProvider.notifier).state.roomDao.deleteAll();
      await ref
          .read(databaseProvider.notifier)
          .state
          .roomDao
          .insertAllData(syncBookBaseData.rooms);
      await ref.read(databaseProvider.notifier).state.shelfDao.deleteAll();
      await ref
          .read(databaseProvider.notifier)
          .state
          .shelfDao
          .insertAllData(syncBookBaseData.shelves);
      await ref.read(databaseProvider.notifier).state.authorDao.deleteAll();
      await ref
          .read(databaseProvider.notifier)
          .state
          .authorDao
          .insertAllData(syncBookBaseData.authors);
      await ref.read(databaseProvider.notifier).state.donorDao.deleteAll();
      await ref
          .read(databaseProvider.notifier)
          .state
          .donorDao
          .insertAllData(syncBookBaseData.donors);
    }
    // await ref
    //     .read(databaseProvider.notifier)
    //     .state
    //     .countryDao
    //     .insertAllData(syncData?.platformPackages ?? []);
    // if (response.platformPackages.isNotEmpty) {
    //   Utils.setPlatformPackageList(response.platformPackages);
    // }

    // if (response.paymentMethods.isNotEmpty) {
    //   Utils.setPaymentMethodsList(response.paymentMethods);
    // }
    //
    // if (response.countries.isNotEmpty) {
    //   Utils.setCountriesList(response.countries);
    // }

    // if (response.bookBaseData != null) {
    //   await Utils.saveBookLists(response.bookBaseData!);
    // }
  }
//TODO :: get all countries
  Future<List<Country>> getAllCountries() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .countryDao
        .getAllData();
  }
  //TODO :: get all authors
  Future<List<AuthorBaseData>> getAllAuthors() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .authorDao
        .getAllData();
  } //TODO :: get all categories
  Future<List<Category>> getAllCategory() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .categoryDao
        .getAllData();
  }
  //TODO :: get all rooms
  Future<List<Room>> getAllRooms() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .roomDao
        .getAllData();
  }
  //TODO :: get all shelf
  Future<List<Shelf>> getAllShelf() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .shelfDao
        .getAllData();
  }
  //TODO :: get all donors
  Future<List<Donor>> getAllDonor() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .donorDao
        .getAllData();
  }
  //TODO :: get all PlatformPackage
  Future<List<PlatformPackage>> getAllPlatformPackage() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .platformPackageDao
        .getAllData();
  }
  //TODO :: get all payment Method
  Future<List<PaymentMethod>> getAllPaymentMethod() async {
    return await ref
        .read(databaseProvider.notifier)
        .state
        .paymentMethodDao
        .getAllData();
  }
  //TODO :: Insert Favorite Books in Db
  // Future<bool> addFavoriteBook(Book book) async {
  //
  //   final dao = ref.read(databaseProvider.notifier).state.favoriteBookDao;
  //
  //   final existing = await dao.getByTitle(book.title ?? "");
  //
  //   if (existing != null) {
  //     return false;
  //   }
  //
  //   await dao.insertData(book);
  //   return true;
  // }
  Future<bool> addFavoriteBook(Book book) async {
    final dao = ref.read(databaseProvider.notifier).state.favoriteBookDao;

    final userId = (await Utils.getUserData())?.user?.id;
    if (userId == null) return false;

    final exists = await dao.exists(book.id!, userId);

    if (exists) return false;

    await dao.insertData(book, userId);

    return true;
  }
  //TODO ::remove all data in the db
  Future<void> removeAllData() async {
    await Utils.clearCacheData();
    // await ref.read(databaseProvider.notifier).state.favoriteBookDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.authorDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.categoryDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.districtDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.divisionDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.donorDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.paymentMethodDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.platformPackageDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.roomDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.shelfDao.deleteAll();
    await ref.read(databaseProvider.notifier).state.unsentDao.deleteAll();
  }
}
