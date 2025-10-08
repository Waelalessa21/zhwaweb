import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/model/store.dart';
import '../../../data/repository/store_repository.dart';

class StoreCubit extends Cubit<StoreState> {
  final StoreRepository _repository = StoreRepository();

  StoreCubit() : super(StoreInitial());

  Future<void> loadStores({
    int page = 1,
    int limit = 10,
    String? search,
    String? city,
    String? sector,
  }) async {
    emit(StoreLoading());

    final result = await _repository.getStores(
      page: page,
      limit: limit,
      search: search,
      city: city,
      sector: sector,
    );

    result.when(
      success: (stores) => emit(StoreLoaded(stores)),
      failure: (message) => emit(StoreError(message)),
    );
  }

  Future<void> createStore(Store store) async {
    final currentState = state;
    List<Store> currentStores = [];

    if (currentState is StoreLoaded) {
      currentStores = List<Store>.from(currentState.stores);
    }

    emit(StoreLoading());

    final result = await _repository.createStore(store);

    result.when(
      success: (createdStore) {
        currentStores.add(createdStore);
        emit(StoreLoaded(currentStores));
      },
      failure: (message) => emit(StoreError(message)),
    );
  }

  Future<void> updateStore(Store store) async {
    final currentState = state;
    List<Store> currentStores = [];

    if (currentState is StoreLoaded) {
      currentStores = List<Store>.from(currentState.stores);
    }

    emit(StoreLoading());

    final result = await _repository.updateStore(store);

    result.when(
      success: (updatedStore) {
        final updatedStores = currentStores.map((s) {
          return s.id == store.id ? updatedStore : s;
        }).toList();
        emit(StoreLoaded(updatedStores));
      },
      failure: (message) => emit(StoreError(message)),
    );
  }

  Future<void> deleteStore(String storeId) async {
    final currentState = state;
    List<Store> currentStores = [];

    if (currentState is StoreLoaded) {
      currentStores = List<Store>.from(currentState.stores);
    }

    emit(StoreLoading());

    final result = await _repository.deleteStore(storeId);

    result.when(
      success: (message) {
        final updatedStores = currentStores
            .where((store) => store.id != storeId)
            .toList();
        emit(StoreLoaded(updatedStores));
      },
      failure: (message) => emit(StoreError(message)),
    );
  }

  void clearError() {
    final currentState = state;
    if (currentState is StoreError) {
      emit(StoreInitial());
    }
  }
}

abstract class StoreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<Store> stores;

  StoreLoaded(this.stores);

  @override
  List<Object?> get props => [stores];
}

class StoreError extends StoreState {
  final String message;

  StoreError(this.message);

  @override
  List<Object?> get props => [message];
}
