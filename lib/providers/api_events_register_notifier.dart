import 'package:flutter_base/generated/l10n.dart';
import 'package:flutter_base/models/request/event_register/EventRegisterRequest.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/login_response/PaymentMethod.dart';
import 'package:flutter_base/models/response/login_response/User.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/response/book_response/Book.dart';
import '../models/response/event/Events.dart';
import '../models/response/login_response/Data.dart';
import '../models/response/server_response.dart';
import '../models/response/subscription_plan/SubscriptionResponseModel.dart';
import '../utils/api_state_model.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

final apiEventRegisterNotifierProvider =
    StateNotifierProvider.autoDispose<ApiEventsNotifier, ApiStatesModel>(
        (ref) => ApiEventsNotifier(ref),
        name: "apiEventRegisterNotifierProvider");

//TODO:: user data provider
final userProvider = StateProvider<User?>((ref) => null);
//TODO:: select payment method
var selectedTypeOfPaymentMethod = StateProvider((ref) =>PaymentMethod());
//TODO:: list of payment method
var typeOfPaymentListStateProvider = StateProvider<List<PaymentMethod>>((ref) => []);
//TODO::proof image for transaction
var pictureOfPaymentProofStateProvider = StateProvider((ref)=> "");
class ApiEventsNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiEventsNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));

//TODO :: subscription by library payment or plans
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


      // Payment Methods
      final List<PaymentMethod> paymentMethods =
          response.paymentMethods ?? [];

      // Update Payment Provider
      _ref
          .read(typeOfPaymentListStateProvider.notifier)
          .state = paymentMethods;

      // Check data
      if (paymentMethods.isNotEmpty) {

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

//TODO Submit register event
  Future<void> apiSubmitRegisterEvent(
      String name,
      String email,
      String phoneNumber,
      String notes,
      int? eventId,

      ) async {
    var apiRequest = EventRegisterRequest(

      chimneyPicture: _ref.watch(pictureOfPaymentProofStateProvider),
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      notes: notes,
    );

    Utils.printInDebug("apiJson: ${apiRequest.toJson()}");
    await submitSubscrionForm(apiRequest,eventId);
  }
  //TODO :: request event register
  Future<void> submitSubscrionForm(EventRegisterRequest requestModel, libraryId) async {
    try {
      state = ApiStatesModel(States.LOADING, pleaseWaitSignIn, null);
      ServerResponse response =
      await _ref.read(authRepository).apiEventRegister(requestModel,libraryId);
      state = ApiStatesModel(States.DATA, response.message??"", response);
    } on DataException catch (error) {
      state = ApiStatesModel(States.ERROR, error.message, null);
    }
  }
}
