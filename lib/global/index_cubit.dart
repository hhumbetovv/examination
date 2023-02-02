import 'package:flutter_bloc/flutter_bloc.dart';

class IndexCubit extends Cubit<int> {
  IndexCubit() : super(0);

  void changeIndex() {
    if (state == 8) {
      emit(0);
    } else {
      emit(state + 1);
    }
  }
}
