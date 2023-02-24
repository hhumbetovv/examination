import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexCubit extends Cubit<int> {
  IndexCubit() : super(0);

  void changeIndex() {
    if (state == 8) {
      ThemeHelper.setThemeIndex(0);
      emit(0);
    } else {
      ThemeHelper.setThemeIndex(state + 1);
      emit(state + 1);
    }
  }

  void getIndex() async {
    int index = await ThemeHelper.getThemeIndex;
    emit(index);
  }
}

class ThemeHelper {
  static Future<bool> setThemeIndex(int index) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt('themeIndex', index);
  }

  static Future<int> get getThemeIndex async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt('themeIndex') ?? 0;
  }
}
