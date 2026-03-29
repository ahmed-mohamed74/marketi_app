

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketi_app/core/services/app_state_service.dart';

class OnbourdCubit extends Cubit<int> {
  final AppStateService appStateService;

  OnbourdCubit(this.appStateService) : super(0);

  void onPageChanged(int index) => emit(index);

  void completeOnboarding() {
    appStateService.completeOnboarding();
  }
}