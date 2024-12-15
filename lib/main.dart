import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/posts_screen.dart';
import 'models/post_model.dart';
import 'data/fake_posts_data_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostsProvider(FakePostsDataSource()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Posts App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2C3E50),
            primary: const Color(0xFF2C3E50),
            secondary: const Color(0xFF3498DB),
            surface: const Color(0xFFF8F9FA),
            background: const Color(0xFFECF0F1),
            error: const Color(0xFFE74C3C),
          ),
          scaffoldBackgroundColor: const Color(0xFFECF0F1),
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF2C3E50),
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 2,
            backgroundColor: const Color(0xFF3498DB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3498DB),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        home: const PostsScreen(),
      ),
    );
  }
}
