import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingopanda_assessment/auth/presentation/auth_screen.dart';
import 'package:lingopanda_assessment/auth/providers/auth_provider.dart';
import 'package:lingopanda_assessment/firebase_options.dart';
import 'package:lingopanda_assessment/news/presentation/my_news.dart';
import 'package:lingopanda_assessment/news/providers/news_provider.dart';
import 'package:lingopanda_assessment/news/repository/news_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(
          create: (context) => NewsProvider(newsRepository: NewsRepository()),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return child!;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null
            ? const MyNews()
            : const AuthScreen(),
      ),
    );
  }
}
