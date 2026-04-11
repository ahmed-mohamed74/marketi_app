part of 'add_favourite_cubit.dart';

sealed class AddFavouriteState extends Equatable {
  const AddFavouriteState();

  @override
  List<Object> get props => [];
}

final class AddFavouriteInitial extends AddFavouriteState {}


final class AddFavouriteProductLoading extends AddFavouriteState {}

final class AddFavouriteProductSuccess extends AddFavouriteState {
  final String message;

  const AddFavouriteProductSuccess(this.message);
}

final class AddFavouriteProductFailure extends AddFavouriteState {
  final String errorMessage;

  const AddFavouriteProductFailure({required this.errorMessage});
}
