import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_test/generated/l10n.dart';
import 'package:flutter_web_test/ui/home_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  // initializeApp(
  //   apiKey: "AIzaSyCpPT6aH4fkW6jWgXJkDQEg-9V6CoiMHx8",
  //   authDomain: "fifi-fdbd4.firebaseapp.com",
  //   databaseURL: "https://fifi-fdbd4-default-rtdb.firebaseio.com/",
  //   projectId: "fifi-fdbd4",
  //   storageBucket: "fifi-fdbd4.appspot.com",
  //   appId: "1:220022986315:web:19f1759065ee5a71775fce",
  //   messagingSenderId: "220022986315",
  // );

  // Database db = database();
  // DatabaseReference ref = db.ref('messages');
  //
  // ref.onValue.listen((e) {
  //   DataSnapshot datasnapshot = e.snapshot;
  //   // Do something with datasnapshot
  // });

  // final DatabaseReference db = FirebaseDatabase().reference();
  // db.child('your_db_child').once().then((result) {
  //   print('result = $result');
  // });

  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化Firebase服務
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [...S.delegate.supportedLocales],
      home: const HomePage(),
    );
  }
}
