import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeCubit extends Cubit<bool> {
  ThemeModeCubit() : super(true);

  void changeMode() {
    ThemeHelper.setThemeMode(!state);
    emit(!state);
  }

  void getMode() async {
    bool mode = await ThemeHelper.getThemeMode;
    emit(mode);
  }
}

class ThemeHelper {
  static Future<bool> setThemeMode(bool mode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool('themeMode', mode);
  }

  static Future<bool> get getThemeMode async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('themeMode') ?? true;
  }
}
