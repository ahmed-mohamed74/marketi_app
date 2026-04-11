part of 'get_favourites_cubit.dart';

sealed class GetFavouriteState extends Equatable {
  const GetFavouriteState();

  @override
  List<Object> get props => [];
}

final class GetFavouritesInitial extends GetFavouriteState {}


final class GetFavouritesProductsLoading extends GetFavouriteState {}

final class GetFavouritesProductsSuccess extends GetFavouriteState {
  final List<ProductModel> favouriteProducts;

  const GetFavouritesProductsSuccess(this.favouriteProducts);
}

final class GetFavouritesProductsFailure extends GetFavouriteState {
  final String errorMessage;

  const GetFavouritesProductsFailure({required this.errorMessage});
}

