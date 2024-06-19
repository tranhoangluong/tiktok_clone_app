import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toptop/provider/gender_model.dart';
import 'package:toptop/provider/loading_model.dart';
import 'package:toptop/provider/login_phone.dart';
import 'package:toptop/provider/save_model.dart';
import 'package:toptop/views/screens/auth/auth_screen.dart';
import 'package:toptop/views/screens/auth/login_phone_screen.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //update app 2024
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GenderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoadingModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SaveModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginPhoneProvider(),
          child: const LoginWithPhoneNumber(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme().copyWith(
            bodySmall: const TextStyle(fontFamily: "Tiktok_Sans"),
            bodyMedium: const TextStyle(fontFamily: "Tiktok_Sans"),
            bodyLarge: const TextStyle(fontFamily: "Tiktok_Sans")
        ),
      ),
      home: const AuthScreen(),
    );
  }
}