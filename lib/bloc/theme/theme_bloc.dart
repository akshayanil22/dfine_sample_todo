import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

// ----------- THEME EVENT ----------- //
abstract class ThemeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {} // New event to load the theme

// ----------- THEME STATE ----------- //
enum AppTheme { light, dark }

class ThemeState extends Equatable {
  final AppTheme theme;
  const ThemeState({required this.theme});

  @override
  List<Object> get props => [theme];
}

// ----------- THEME BLOC ----------- //
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(theme: AppTheme.light)) {
    on<ToggleTheme>(_handleToggleTheme);
    on<LoadTheme>(_handleLoadTheme);
  }


  Future<void> _handleLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(ThemeState(theme: isDarkMode ? AppTheme.dark : AppTheme.light));
  }

  Future<void> _handleToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    final newTheme = state.theme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    emit(ThemeState(theme: newTheme));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newTheme == AppTheme.dark);
  }
}
