import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/core/theme/theme.dart';
import 'package:my_recipe/providers/theme_provider.dart';
import 'package:my_recipe/screens/contact_us_screen.dart';
import 'package:my_recipe/screens/login_screen.dart';
import 'package:my_recipe/screens/main_screen.dart';
import 'package:my_recipe/screens/post_screen.dart';
import 'package:my_recipe/screens/premium_ad_screen.dart';
import 'package:my_recipe/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_recipe/services/noti_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await Supabase.initialize(
    url: "https://wcqmjwveaoxqjubuoena.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndjcW1qd3ZlYW94cWp1YnVvZW5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3ODMzNzgsImV4cCI6MjA1NzM1OTM3OH0.qYP_P5H9H81yEHddfSa-fLV2vbh3jJwMd5c391W5Ai8",
  );

  // Initialize the notification
  NotiService().initNotifiction();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MyRecipe!',
      theme:
          ref.watch(isDarkTheme)
              ? CustomTheme.darkTheme
              : CustomTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainScreen(),
        '/premium-ad': (context) => PremiumAdScreen(),
        '/post': (context) => PostScreen(),
        '/contact-us': (context) => ContactUs(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
