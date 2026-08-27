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
import '../models/response/subscription_plan/SubscriptionResponseModel.dart';
import '../utils/api_state_model.dart';

final apiEventsNotifierProvider =
    StateNotifierProvider.autoDispose<ApiEventsNotifier, ApiStatesModel>(
        (ref) => ApiEventsNotifier(ref),
        name: "apiEventsNotifierProvider");
//TODO:: list of event
final eventsProvider = StateProvider<List<Event>>((ref) => []);
class ApiEventsNotifier extends StateNotifier<ApiStatesModel> {
  final AutoDisposeStateNotifierProviderRef _ref;

  ApiEventsNotifier(this._ref) : super(ApiStatesModel(States.IDLE, "", null));
  // //TODO::Fetching libraries
  Future<void> fetchEvents() async {
    try {
      state = ApiStatesModel(States.LOADING, "Fetching events...", null);

      final List<Event> eventsList =
          await _ref.read(authRepository).getEvents();

      if (eventsList.isNotEmpty) {
        _ref.read(eventsProvider.notifier).state = eventsList;

        state = ApiStatesModel(
          States.DATA,
          "Events fetched successfully",
          eventsList,
        );
      } else {
        _ref.read(eventsProvider.notifier).state = [];
        state = ApiStatesModel(
          States.ERROR,
          "No events found",
          null,
        );
      }
    } on DataException catch (error) {
      _ref.read(eventsProvider.notifier).state = [];
      state = ApiStatesModel(
        States.ERROR,
        error.message,
        null,
      );
    }
  }
}
