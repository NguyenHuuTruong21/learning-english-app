import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/vocabulary_provider.dart';
import 'providers/learning_progress_provider.dart';
import 'providers/theme_provider.dart'; // ✅ THÊM VÀO ĐÂY

import 'screens/indexscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅ Thêm theme provider
        ChangeNotifierProvider(create: (_) => VocabularyProvider()),
        ChangeNotifierProvider(create: (_) => LearningProgressProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'English Learning App',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            home: const IndexScreen(),
          );
        },
      ),
    );
  }
}
