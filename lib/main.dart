import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat318/providers/auth_service.dart';
import 'package:flutter_appchat318/providers/chat.dart';
import 'package:flutter_appchat318/views/signIn_page.dart';
import 'package:flutter_appchat318/views/signUp_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignUpPage(),
      ),
    );

    //   return MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider(create: (_) => Chat()),
    //       Provider<AuthService>(
    //           create: (_) => AuthService(FirebaseAuth.instance)),
    //       StreamProvider(
    //         create: (context) => context.read<AuthService>().authStateChanges,
    //         initialData: null,
    //       ),
    //     ],
    //     child: MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: SignUpPage(),
    //     ),
    //   );
  }
}
