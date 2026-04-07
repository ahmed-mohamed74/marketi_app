import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/auth_feature/data/models/user_model.dart';
import 'package:marketi_app/features/profile_feature/data/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit({required this.profileRepository}) : super(ProfileInitial());
  Future<void> getUserData() async {
    emit(ProfileLoading());
    final cachedUser = CacheHelper().getData(key: ApiKey.user);

    if (cachedUser != null) {
      final user = UserModel.fromJson(jsonDecode(cachedUser));
      emit(ProfileSuccess(user: user));
    }
    final response = await profileRepository.getUserProfileData();
    response.fold(
      (errorMessage) => emit(ProfileFailure(errorMessage: errorMessage)),
      (response) => emit(ProfileSuccess(user: response)),
    );
  }
}
