import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize .env File
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
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
