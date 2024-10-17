import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizapp_screen/bloc/screen_app_bloc.dart';
import 'package:quizapp_screen/presentation/main_page.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  runApp(const ScreenApp());
}

class ScreenApp extends StatelessWidget {
  const ScreenApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screen Quizapp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => ScreenAppBloc()..add(ConnectToServer()),
        child: const MainPage(),
      ),
    );
  }
}
