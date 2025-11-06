import 'package:doctor/firebase_options.dart';
import 'package:doctor/providers/auth_provider.dart';
import 'package:doctor/screens/admin/admin_home_screen.dart';
import 'package:doctor/screens/doctor/doctor_home_screen.dart';
import 'package:doctor/screens/patient/patient_home_screen.dart';
import 'package:doctor/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'constants.dart'; // Import the color constants
import 'services/database_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize sample data (development only)
    final dbInitializer = DatabaseInitializer();
    await dbInitializer.initializeData();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4287F5), // Set app's primary color
          secondary: Colors.orange,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4287F5),
          elevation: 0,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF4287F5), // Set button background color
          textTheme: ButtonTextTheme.primary, // Set button text color to white
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF4287F5), // Button text color
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            textStyle: TextStyle(fontSize: 16), // Button text styling
          ),
        ),
      ),

      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            switch (auth.role) {
              case 'admin':
                return AdminHomeScreen();
              case 'doctor':
                return DoctorHomeScreen();
              case 'patient':
                return PatientHomeScreen();
              default:
                return SplashScreen();
            }
          }

          return SplashScreen();
        },
      ),
      routes: {
        '/admin-home': (context) => AdminHomeScreen(),
        '/doctor-home': (context) => DoctorHomeScreen(),
        '/patient-home': (context) => PatientHomeScreen(),
      },
    );
  }
}
