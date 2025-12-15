import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/buoi3.dart';
import 'package:flutter_application_baikiemtra/buoi4.dart';
import 'package:flutter_application_baikiemtra/demso.dart';
import 'package:flutter_application_baikiemtra/bodemthoigian.dart';
import 'package:flutter_application_baikiemtra/chisoBMI.dart';
import 'package:flutter_application_baikiemtra/danhgia.dart';
import 'package:flutter_application_baikiemtra/dangky.dart';
import 'package:flutter_application_baikiemtra/dangnhap.dart';
import 'package:flutter_application_baikiemtra/userprofile.dart';
import 'package:flutter_application_baikiemtra/hometesttoken.dart';
import 'package:flutter_application_baikiemtra/my_product.dart';
import 'package:flutter_application_baikiemtra/invoices_page.dart';
import 'package:flutter_application_baikiemtra/my_place.dart';
import 'package:flutter_application_baikiemtra/classroom.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';
import 'package:flutter_application_baikiemtra/my_profile.dart';
import 'package:flutter_application_baikiemtra/my_home_page.dart';
import 'package:flutter_application_baikiemtra/pages/new_list_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SimpleHomePage(), // <<< ĐÃ SỬA: Thêm route cho '/'
        '/buoi3': (context) => const Buoi3(),
        '/buoi4': (context) => const Buoi4(),
        '/demso': (context) => const Demso(),
        '/bodemthoigian': (context) => const BoDemTime(),
        '/chisoBMI': (context) => const ChiSoBMI(),
        '/danhgia': (context) => const DanhGia(),
        '/dangky': (context) => const DangKy(),
        '/dangnhap': (context) => const DangNhap(),
        '/userprofile': (context) => const Userporfile(),
        '/hometesttoken': (context) => const Hometesttoken(),
        '/myprofile': (context) => const MyProfile(),
        '/my_product': (context) => const MyProduct(),
        '/invoices': (context) => const InvoicesPage(),
        '/my_place': (context) => const MyPlace(),
        '/classroom': (context) => const ClassRomm(),
        '/newslist': (context) => const NewsListPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
// ... (Phần code này không bị ảnh hưởng)
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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
