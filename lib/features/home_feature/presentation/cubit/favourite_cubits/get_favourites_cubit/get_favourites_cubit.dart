
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';
import 'package:marketi_app/features/home_feature/data/repositories/favourite_repository.dart';

part 'get_favourites_state.dart';

class GetFavouriteCubit extends Cubit<GetFavouriteState> {
  final FavouriteRepository favouriteRepository;

  GetFavouriteCubit({required this.favouriteRepository}) : super(GetFavouritesInitial());

  Future<void> getFavouriteProducts() async {
    emit(GetFavouritesProductsLoading());
    final response = await favouriteRepository.getFavouriteProducts();
    response.fold(
      (error) => emit(GetFavouritesProductsFailure(errorMessage: error)),
      (products) => emit(GetFavouritesProductsSuccess(products)),
    );
  }
}
