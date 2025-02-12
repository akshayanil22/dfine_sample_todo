import 'package:dfine_todo/bloc/tasks/tasks_bloc.dart';
import 'package:dfine_todo/bloc/todo/todo_bloc.dart';
import 'package:dfine_todo/screens/splash_screen.dart';
import 'package:dfine_todo/shared/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/theme/theme_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => TodoBloc()),
        BlocProvider(create: (context) => TaskBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: state.theme == AppTheme.light ? ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                shape: CircleBorder(),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey.shade900
              )
          ) : ThemeData.dark().copyWith(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blueGrey.shade900,
            ),
              scaffoldBackgroundColor: Colors.blueGrey.shade900,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              shape: CircleBorder(),
                foregroundColor: Colors.blueGrey.shade900,
                backgroundColor: Colors.white
            )

          ),
          home: SplashScreen(),
        );
      },
    );
  }
}

