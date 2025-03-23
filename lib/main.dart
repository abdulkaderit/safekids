
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safekids/screens/provider/language_provider.dart';
import 'package:safekids/screens/provider/theme_provider.dart';
import 'package:safekids/services/auth_services.dart';
import 'app/my_app.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  runApp(
      MultiProvider(
          providers: [
            Provider(create: (context) => AuthService()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ],
        child: MyApp(),
      )
  );
}