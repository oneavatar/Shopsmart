import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsmart/core/theme/bloc/theme_event.dart';
import 'package:shopsmart/core/theme/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(isDarkMode: false)) {
    on<ToggleThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final newThemeMode = !state.isDarkMode;
      await prefs.setBool('isDarkMode', newThemeMode);
      emit(ThemeState(isDarkMode: newThemeMode));
    });

    on<LoadThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final isDarkMode = prefs.getBool('isDarkMode') ?? false;
      emit(ThemeState(isDarkMode: isDarkMode));
    });

    add(LoadThemeEvent());
  }
}
