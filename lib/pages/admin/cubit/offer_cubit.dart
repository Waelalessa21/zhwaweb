import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/offer.dart';
import '../../../data/repository/offer_repository.dart';

class OfferCubit extends Cubit<OfferState> {
  final OfferRepository _repository = OfferRepository();

  OfferCubit() : super(OfferInitial());

  Future<void> loadOffers({
    int page = 1,
    int limit = 10,
    String? search,
    String? storeId,
    bool activeOnly = true,
  }) async {
    emit(OfferLoading());

    final result = await _repository.getOffers(
      page: page,
      limit: limit,
      search: search,
      storeId: storeId,
      activeOnly: activeOnly,
    );

    result.when(
      success: (offers) => emit(OfferLoaded(offers)),
      failure: (message) => emit(OfferError(message)),
    );
  }

  Future<void> createOffer(Offer offer) async {
    emit(OfferLoading());

    final result = await _repository.createOffer(offer);

    result.when(
      success: (createdOffer) {
        final currentState = state;
        if (currentState is OfferLoaded) {
          final updatedOffers = List<Offer>.from(currentState.offers);
          updatedOffers.add(createdOffer);
          emit(OfferLoaded(updatedOffers));
        } else {
          emit(OfferLoaded([createdOffer]));
        }
      },
      failure: (message) => emit(OfferError(message)),
    );
  }

  Future<void> updateOffer(Offer offer) async {
    emit(OfferLoading());

    final result = await _repository.updateOffer(offer);

    result.when(
      success: (updatedOffer) {
        final currentState = state;
        if (currentState is OfferLoaded) {
          final updatedOffers = currentState.offers.map((o) {
            return o.id == offer.id ? updatedOffer : o;
          }).toList();
          emit(OfferLoaded(updatedOffers));
        }
      },
      failure: (message) => emit(OfferError(message)),
    );
  }

  Future<void> deleteOffer(String offerId) async {
    emit(OfferLoading());

    final result = await _repository.deleteOffer(offerId);

    result.when(
      success: (message) {
        final currentState = state;
        if (currentState is OfferLoaded) {
          final updatedOffers = currentState.offers
              .where((offer) => offer.id != offerId)
              .toList();
          emit(OfferLoaded(updatedOffers));
        }
      },
      failure: (message) => emit(OfferError(message)),
    );
  }

  void clearError() {
    final currentState = state;
    if (currentState is OfferError) {
      emit(OfferInitial());
    }
  }
}

abstract class OfferState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OfferInitial extends OfferState {}

class OfferLoading extends OfferState {}

class OfferLoaded extends OfferState {
  final List<Offer> offers;

  OfferLoaded(this.offers);

  @override
  List<Object?> get props => [offers];
}

class OfferError extends OfferState {
  final String message;

  OfferError(this.message);

  @override
  List<Object?> get props => [message];
}
