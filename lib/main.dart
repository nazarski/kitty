import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/database/expenses_database.dart';

import 'package:kitty/repository/database_repository.dart';
import 'package:kitty/repository/secure_storage_repository.dart';
import 'package:kitty/routes/app_routes.dart';
import 'package:kitty/themes/app_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (context) =>
          UserBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoutes.generateRoute,
        theme: AppThemeData.mainTheme,
      ),
    ),
  );
}
