import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);
  void updateIndex(int index) => emit(index);
}
