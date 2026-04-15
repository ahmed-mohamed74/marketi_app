
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/favorite/data/repositories/favourite_repository.dart';

part 'add_favourite_state.dart';

class AddFavouriteCubit extends Cubit<AddFavouriteState> {
    final FavouriteRepository favouriteRepository;

  AddFavouriteCubit({required this.favouriteRepository}) : super(AddFavouriteInitial());

  Future<void> addFavouriteProduct({required String id}) async {
    emit(AddFavouriteProductLoading());
    final response = await favouriteRepository.addFavouriteProduct(id: id);
    response.fold(
      (error) => emit(AddFavouriteProductFailure(errorMessage: error)),
      (message) => emit(AddFavouriteProductSuccess(message)),
    );
  }
}
