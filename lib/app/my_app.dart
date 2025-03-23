import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../screens/auth_wrapper.dart';
import '../screens/child/child_dashboard.dart';
import '../screens/child/child_profile.dart';
import '../screens/dashbord_screen.dart';
import '../screens/home_screen.dart';
import '../screens/parent/parent_dashboard.dart';
import '../screens/parent/parent_profile.dart';
import '../screens/provider/theme_provider.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';
import '../utils/globals.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context,orientation,deviceType){
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: AppGlobals.navigatorKey,
            title: 'Parental Control App', // Set global navigator key
            theme: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16
                ),
                border: _getZeroBorder(),
                enabledBorder: _getZeroBorder(),
                errorBorder: _getZeroBorder(),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size.fromWidth(double.maxFinite),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    )
                ),
              ),
              primarySwatch: Colors.blue,
              hintColor: Colors.orange,
              fontFamily: 'Poppins',
              textTheme: TextTheme(
                displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: true,
              ),
            ),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => SplashScreen(),
              '/parentDashboard': (context) => ParentDashboard(),
              '/childDashboard': (context) => ChildDashboard(childID: '',),
              '/Settings': (context) => SettingsScreen(),
              '/Home': (context) => HomePageContent(),
              '/Dashbord': (context) => DashbordScreen(),
              '/ChildProfile': (context) => ChildProfile(),
              '/ParentProfile': (context) => ParentProfile(),

            },
            home: AuthWrapper(),
          );
        }
    );
  }
  OutlineInputBorder _getZeroBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide.none,
    );
  }
}
