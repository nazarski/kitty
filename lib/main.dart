import 'package:flutter/material.dart';
import 'package:kitty/database/database_repository.dart';
import 'package:kitty/pages/check_screen/check_screen.dart';
import 'package:kitty/pages/main_page.dart';
import 'package:kitty/routes/app_routes.dart';
import 'package:kitty/themes/app_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
      theme: AppThemeData.mainTheme,
       ),
  );
}
