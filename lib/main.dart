import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gastos/month_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA27hMN6dvPIXmHsFJ5cozJweDOvak21j8",
      authDomain: "gastos-47fab.firebaseapp.com",
      projectId: "gastos-47fab",
      storageBucket: "gastos-47fab.appspot.com",
      messagingSenderId: "137916224459",
      appId: "1:137916224459:web:f39797e5b244e0b5165c4e",
      measurementId: "G-2RMP0WE1VM",
    ),
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gastos",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _controller;
  int currentPage = 6;
  late Stream<QuerySnapshot> _query;

  @override
  void initState() {
    super.initState();

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );

    _updateQuery();
  }

  void _updateQuery() {
    _query = FirebaseFirestore.instance
        .collection('expenses')
        .where('month', isEqualTo: currentPage + 1)
        .snapshots();
  }

  Widget _bottomAction(IconData icon) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            _bottomAction(FontAwesomeIcons.chartPie),
            SizedBox(width: 48.0),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(Icons.settings),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
        shape: CircleBorder(),
        backgroundColor: Colors.pink,
        elevation: 6.0,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return MonthWidget(documents: snapshot.data!.docs);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.pink.withOpacity(0.5));
    final unSelected = TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.normal,
        color: Colors.pink.withOpacity(0.3));

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }
    return Align(
        alignment: _alignment,
        child: Text(
          name,
          style: position == currentPage ? selected : unSelected,
        ));
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;
            _updateQuery();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem("January", 0),
          _pageItem("February", 1),
          _pageItem("March", 2),
          _pageItem("April", 3),
          _pageItem("May", 4),
          _pageItem("June", 5),
          _pageItem("July", 6),
          _pageItem("August", 7),
          _pageItem("September", 8),
          _pageItem("October", 9),
          _pageItem("November", 10),
          _pageItem("December", 11),
        ],
      ),
    );
  }
}
