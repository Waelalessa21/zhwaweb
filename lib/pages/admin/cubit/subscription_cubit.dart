import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/subscription.dart';
import '../../../data/repository/subscription_repository.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final SubscriptionRepository _repository = SubscriptionRepository();

  SubscriptionCubit() : super(SubscriptionInitial());

  Future<void> loadSubscriptions({String status = 'pending'}) async {
    emit(SubscriptionLoading());

    final result = await _repository.getSubscriptions(status: status);

    result.when(
      success: (subscriptions) => emit(SubscriptionLoaded(subscriptions)),
      failure: (message) => emit(SubscriptionError(message)),
    );
  }

  Future<void> createSubscription(Subscription subscription) async {
    final currentState = state;
    List<Subscription> currentSubscriptions = [];

    if (currentState is SubscriptionLoaded) {
      currentSubscriptions = List<Subscription>.from(
        currentState.subscriptions,
      );
    }

    emit(SubscriptionLoading());

    final result = await _repository.createSubscription(subscription);

    result.when(
      success: (createdSubscription) {
        currentSubscriptions.add(createdSubscription);
        emit(SubscriptionLoaded(currentSubscriptions));
      },
      failure: (message) => emit(SubscriptionError(message)),
    );
  }

  Future<void> approveSubscription(String subscriptionId) async {
    final currentState = state;
    List<Subscription> currentSubscriptions = [];

    if (currentState is SubscriptionLoaded) {
      currentSubscriptions = List<Subscription>.from(
        currentState.subscriptions,
      );
    }

    emit(SubscriptionLoading());

    final result = await _repository.approveSubscription(subscriptionId);

    result.when(
      success: (approvedSubscription) {
        final updatedSubscriptions = currentSubscriptions.map((s) {
          return s.id == subscriptionId ? approvedSubscription : s;
        }).toList();
        emit(SubscriptionLoaded(updatedSubscriptions));
      },
      failure: (message) => emit(SubscriptionError(message)),
    );
  }

  Future<void> rejectSubscription(String subscriptionId) async {
    final currentState = state;
    List<Subscription> currentSubscriptions = [];

    if (currentState is SubscriptionLoaded) {
      currentSubscriptions = List<Subscription>.from(
        currentState.subscriptions,
      );
    }

    emit(SubscriptionLoading());

    final result = await _repository.rejectSubscription(subscriptionId);

    result.when(
      success: (rejectedSubscription) {
        final updatedSubscriptions = currentSubscriptions.map((s) {
          return s.id == subscriptionId ? rejectedSubscription : s;
        }).toList();
        emit(SubscriptionLoaded(updatedSubscriptions));
      },
      failure: (message) => emit(SubscriptionError(message)),
    );
  }

  void clearError() {
    final currentState = state;
    if (currentState is SubscriptionError) {
      emit(SubscriptionInitial());
    }
  }
}

abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Subscription> subscriptions;

  SubscriptionLoaded(this.subscriptions);

  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
