
import 'package:flutter_base/models/request/subscription_detail/SubscriptionDetailRequestModel.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/login_response/PlatformPackage.dart';
import 'package:flutter_base/models/response/subscription_plan/SubscriptionResponseModel.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/login_response/PaymentMethod.dart';
import '../models/response/server_response.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiSubscriptionDetailNotifierProvider =
    StateNotifierProvider.autoDispose<ApiSubscriptionDetailNotifier, ApiStatesModel>(
        (ref) => ApiSubscriptionDetailNotifier(ref),
        name: "apiSubscriptionDetailNotifierProvider");
//TODO :: select payment method provider
var selectedTypeOfPaymentMethod = StateProvider((ref) =>PaymentMethod());
//TODO :: list payment method provider
var typeOfPaymentListStateProvider = StateProvider<List<PaymentMethod>>((ref) => []);
//TODO :: select plat form method provider
var selectedTypeOfPlatForm = StateProvider((ref) =>PlatformPackage());
//TODO :: list  plat form method provider
var typeOfPlatformPackageListStateProvider = StateProvider<List<PlatformPackage>>((ref) => []);
//TODO :: select picture of proof transaction
var pictureOfTransctionStateProvider = StateProvider((ref)=> "");
//TODO :: form submitted
final isFormSubmittedProvider= StateProvider((ref) => false);

class ApiSubscriptionDetailNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiSubscriptionDetailNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
//TODO :: subscription api call
  Future<void> apiSubmitSubscriptionForm(
      int? libraryId,
      ) async {
    var apiRequest = SubscriptionDetailRequestModel(

      chimneyPicture: _ref.watch(pictureOfTransctionStateProvider),
      paymentName: _ref.read(selectedTypeOfPaymentMethod)?.id.toString() ?? '',
      subscriptionType: _ref.read(selectedTypeOfPlatForm)?.id.toString() ?? '',
    );

    Utils.printInDebug("apiJson: ${apiRequest.toJson()}");
    await submitSubscrionForm(apiRequest,libraryId);
  }
  //TODO :: submit subscription api
  Future<void> submitSubscrionForm(SubscriptionDetailRequestModel requestModel, libraryId) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response =
      await _ref.read(authRepository).apiSubmitSubscriptionDetail(requestModel,libraryId);
      state = ApiStatesModel(States.DATA, response.message??"", response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
  //TODO :: Get all payment methods
  Future<void> getAllPaymentMethod() async {
    List<PaymentMethod> dataList =
    await _ref.read(authRepository).getAllPaymentMethod();
    _ref.read(typeOfPaymentListStateProvider.notifier).state = dataList;
  }
  //TODO :: Get Subscription Plans + Payment Methods By Library
  Future<void> getSubscriptionByLibrary(int libraryId) async {

    try {

      state = ApiStatesModel(
        States.LOADING,
        "Fetching subscription data...",
        null,
      );

      final SubscriptionResponseModel response =
      await _ref
          .read(authRepository)
          .getSubscriptionByLibrary(libraryId);

      // Plans
      final List<PlatformPackage> plans =
          response.plans ?? [];

      // Payment Methods
      final List<PaymentMethod> paymentMethods =
          response.paymentMethods ?? [];

      // Update Plans Provider
      _ref
          .read(typeOfPlatformPackageListStateProvider.notifier)
          .state = plans;

      // Update Payment Provider
      _ref
          .read(typeOfPaymentListStateProvider.notifier)
          .state = paymentMethods;

      // Check data
      if (plans.isNotEmpty || paymentMethods.isNotEmpty) {

        state = ApiStatesModel(
          States.DATA,
          "Subscription data fetched successfully",
          response,
        );

      } else {

        state = ApiStatesModel(
          States.ERROR,
          "No subscription data found",
          null,
        );
      }

    } on DataException catch (error) {

      // Clear providers on error
      _ref
          .read(typeOfPlatformPackageListStateProvider.notifier)
          .state = [];

      _ref
          .read(typeOfPaymentListStateProvider.notifier)
          .state = [];

      state = ApiStatesModel(
        States.ERROR,
        error.message,
        null,
      );
    }
  }
}
