part of 'delete_favourite_cubit.dart';

sealed class DeleteFavouriteState extends Equatable {
  const DeleteFavouriteState();

  @override
  List<Object> get props => [];
}

final class DeleteFavouriteInitial extends DeleteFavouriteState {}
final class DeleteFavouriteProductLoading extends DeleteFavouriteState {}

final class DeleteFavouriteProductSuccess extends DeleteFavouriteState {
  final String message;

  const DeleteFavouriteProductSuccess(this.message);
}

final class DeleteFavouriteProductFailure extends DeleteFavouriteState {
  final String errorMessage;

  const DeleteFavouriteProductFailure({required this.errorMessage});
}