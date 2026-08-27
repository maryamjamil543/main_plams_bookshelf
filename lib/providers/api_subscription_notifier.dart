import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/login_response/PaymentMethod.dart';
import '../models/response/login_response/PlatformPackage.dart';
import '../models/response/subscription_plan/Subscription.dart';
import '../models/response/subscription_plan/SubscriptionResponseModel.dart';
import '../utils/api_state_model.dart';

final apiSubscriptionNotifierProvider =
    StateNotifierProvider.autoDispose<ApiSubscriptionNotifier, ApiStatesModel>(
        (ref) => ApiSubscriptionNotifier(ref),
        name: "apiSubscriptionNotifierProvider");
//TODO :: subscription provider
final subscriptionProvider = StateProvider<List<Subscription>>((ref) => []);
//TODO :: book listing
final booksListProvider = StateProvider<List<Book>>((ref) => []);
//TODO :: platFrom provider
var selectedTypeOfPlatForm = StateProvider((ref) =>PlatformPackage());
//TODO :: list platFrom provider
var typeOfPlatformPackageListStateProvider = StateProvider<List<PlatformPackage>>((ref) => []);
class ApiSubscriptionNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiSubscriptionNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));

  //TODO::Fetching libraries
  Future<void> fetchSubscription() async {
    try {
      state = ApiStatesModel(States.LOADING, "Fetching subscription...", null);

      final response = await _ref.read(authRepository).getSubscpritonPlan();

      if (response.data != null && (response.data as List).isNotEmpty) {
        // Save libraries in separate provider
        _ref.read(subscriptionProvider.notifier).state = response.data as List<Subscription>;

        state = ApiStatesModel(States.DATA, "Libraries fetched", response.data);
      } else {
        state = ApiStatesModel(States.ERROR, "No libraries found", null);
        _ref.read(subscriptionProvider.notifier).state = []; // clear provider
      }
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
      _ref.read(subscriptionProvider.notifier).state = []; // clear provider
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
  //TODO :: get al platfrompackage through api
  // Future<void> getAllPlatformPackageFromApi() async {
  //   try {
  //     state = ApiStatesModel(States.LOADING, "Fetching packages...", null);
  //
  //     final List<PlatformPackage> dataList =
  //     await _ref.read(authRepository).getAllPlatfromPackage();
  //
  //     if (dataList.isNotEmpty) {
  //
  //       // Dropdown provider update
  //       _ref
  //           .read(typeOfPlatformPackageListStateProvider.notifier)
  //           .state = dataList;
  //
  //       state = ApiStatesModel(
  //         States.DATA,
  //         "Packages fetched successfully",
  //         dataList,
  //       );
  //
  //     } else {
  //
  //       _ref
  //           .read(typeOfPlatformPackageListStateProvider.notifier)
  //           .state = [];
  //
  //       state = ApiStatesModel(
  //         States.ERROR,
  //         "No packages found",
  //         null,
  //       );
  //     }
  //
  //   } on DataException catch (error) {
  //
  //     _ref
  //         .read(typeOfPlatformPackageListStateProvider.notifier)
  //         .state = [];
  //
  //     state = ApiStatesModel(
  //       States.ERROR,
  //       error.message,
  //       null,
  //     );
  //   }
  // }
  //TODO :: Get Subscription Plans By Library
  //TODO:: Subscription by library id
  Future<void> getSubscriptionByLibrary(int libraryId) async {
    try {

      state = ApiStatesModel(
        States.LOADING,
        "Fetching subscription plans...",
        null,
      );

      final SubscriptionResponseModel response =
      await _ref
          .read(authRepository)
          .getSubscriptionByLibrary(libraryId);

      final List<PlatformPackage> plans = response.plans ?? [];

      // Payment methods list
      final List<PaymentMethod> paymentMethods =
          response.paymentMethods ?? [];

      if (plans.isNotEmpty) {

        // Update plans provider
        _ref
            .read(typeOfPlatformPackageListStateProvider.notifier)
            .state = plans;



        state = ApiStatesModel(
          States.DATA,
          "Subscription fetched successfully",
          response,
        );

      } else {

        _ref
            .read(typeOfPlatformPackageListStateProvider.notifier)
            .state = [];

        // _ref
        //     .read(paymentMethodListProvider.notifier)
        //     .state = [];

        state = ApiStatesModel(
          States.ERROR,
          "No subscription plans found",
          null,
        );
      }

    } on DataException catch (error) {

      _ref
          .read(typeOfPlatformPackageListStateProvider.notifier)
          .state = [];

      // _ref
      //     .read(paymentMethodListProvider.notifier)
      //     .state = [];

      state = ApiStatesModel(
        States.ERROR,
        error.message,
        null,
      );
    }
  }
  //TODO :: Get all Subscription
  Future<void> getAllPlatformPackage() async {
    List<PlatformPackage> dataList =
    await _ref.read(authRepository).getAllPlatformPackage();
    _ref.read(typeOfPlatformPackageListStateProvider.notifier).state = dataList;
  }
}
