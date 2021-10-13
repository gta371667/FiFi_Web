import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final DatabaseReference db = FirebaseDatabase().reference();
    Map<String, dynamic> map = {};

    map['t1'] = 'tttt111';
    map['t2'] = '2222222222';

    db.update(map).then((value) => print('dddddd'));

    // db.child('your_db_child').once().then((result) {
    //   print('result = $result');
    //   result
    //   .
    // });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
