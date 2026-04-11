
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/data/repositories/favourite_repository.dart';

part 'delete_favourite_state.dart';

class DeleteFavouriteCubit extends Cubit<DeleteFavouriteState> {
    final FavouriteRepository favouriteRepository;

  DeleteFavouriteCubit({required this.favouriteRepository}) : super(DeleteFavouriteInitial());

  Future<void> deleteFavouriteProduct({required String id}) async {
    emit(DeleteFavouriteProductLoading());
    final response = await favouriteRepository.deleteFavouriteProduct(id: id);
    response.fold(
      (error) => emit(DeleteFavouriteProductFailure(errorMessage: error)),
      (message) => emit(DeleteFavouriteProductSuccess(message)),
    );
  }
}
