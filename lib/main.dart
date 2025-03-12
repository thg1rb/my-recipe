import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe/core/theme/theme.dart';
import 'package:my_recipe/providers/theme_provider.dart';
import 'package:my_recipe/screens/login_screen.dart';
import 'package:my_recipe/screens/main_screen.dart';
import 'package:my_recipe/screens/premium_ad_screen.dart';
import 'package:my_recipe/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that widget binding is initialized before calling Firebase.initializeApp()
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MyRecipe! ',
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
      },
    );
  }
}
