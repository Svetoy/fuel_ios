import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_flutter/canceled/notification_api.dart';
import 'package:todo_flutter/canceled/test.dart';
import 'package:todo_flutter/l10n/all_locales.dart';
import 'package:todo_flutter/pages/bottom_nav.dart';
import 'package:todo_flutter/pages/start_page.dart';
import 'package:todo_flutter/service/firebase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi().initNotification();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = StartPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkLogin();
  }

  void checkLogin() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        currentPage = const BottomNavBar();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: currentPage,
    );
  }
}
