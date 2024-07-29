import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gastos/pages/expenses_category_page.dart';
import 'package:flutter_gastos/utils/login_state.dart';
import 'package:flutter_gastos/utils/month_widget.dart';
import 'package:flutter_gastos/utils/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:flutter_gastos/repository/expenses_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var globalKey = RectGetter.createGlobalKey();
  late Rect buttonRect;

  late PageController _controller;
  int currentPage = DateTime.now().month - 1;
  late Stream<QuerySnapshot> _query;
  GraphType currentType = GraphType.LINES;

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
    print("Current page: $currentPage, Month: ${currentPage + 1}");

    final user = Provider.of<LoginState>(context, listen: false).user;
    if (user != null) {
      final expensesRepository = ExpensesRepository(user.uid);
      _query = expensesRepository.queryByMonth(currentPage + 1);
    }
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: () => callback(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        color: const Color.fromARGB(255, 71, 187, 172).withOpacity(0.5),
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history, () {
              setState(() {
                currentType = GraphType.LINES;
              });
            }),
            _bottomAction(FontAwesomeIcons.chartPie, () {
              setState(() {
                currentType = GraphType.PIE;
              });
            }),
            const SizedBox(width: 48.0),
            _bottomAction(FontAwesomeIcons.wallet, () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExpensesByCategoryPage(),
                ),
              );
            }),
            _bottomAction(Icons.settings, () {
              Provider.of<LoginState>(context, listen: false).logout();
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: RectGetter(
        key: globalKey,
        child: FloatingActionButton(
          onPressed: () {
            buttonRect = RectGetter.getRectFromKey(globalKey)!;
            Navigator.of(context).pushNamed('/add');
          },
          shape: const CircleBorder(),
          backgroundColor: const Color.fromARGB(255, 71, 187, 172),
          elevation: 6.0,
          child: const Icon(Icons.add),
        ),
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
                  return const Center(child: CircularProgressIndicator());
                default:
                  List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];
                  int daysOfMonth =
                      daysInMonth(DateTime.now().year, currentPage + 1);
                  return MonthWidget(
                    documents: documents,
                    days: daysOfMonth,
                    graphType: currentType,
                    month: DateTime.now().month,
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String name, int position) {
    Alignment alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 71, 187, 172).withOpacity(0.5),
    );
    final unSelected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 71, 187, 172).withOpacity(0.3),
    );

    if (position == currentPage) {
      alignment = Alignment.center;
    } else if (position > currentPage) {
      alignment = Alignment.centerRight;
    } else {
      alignment = Alignment.centerLeft;
    }
    return Align(
      alignment: alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unSelected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: const Size.fromHeight(70.0),
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
