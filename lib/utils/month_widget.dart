import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gastos/pages/details_page.dart';
import 'package:flutter_gastos/utils/graph_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GraphType {
  LINES,
  PIE,
}

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final int days;
  final GraphType graphType;
  final int month;

  MonthWidget({
    super.key,
    required this.documents,
    required this.days,
    required this.graphType,
    required this.month,
  })  : total = documents.isNotEmpty
            ? documents
                .map((doc) => (doc['value'] as num?) ?? 0.0)
                .fold(0.0, (a, b) => a + b.toDouble())
            : 0.0,
        perDay = List.generate(days, (index) {
          return documents
              .where((doc) => doc['day'] == (index + 1))
              .map((doc) => (doc['value'] as num?) ?? 0.0)
              .fold(0.0, (a, b) => a + b.toDouble());
        }),
        categories = documents.isNotEmpty
            ? documents.fold({}, (Map<String, double> map, document) {
                String category = document['category'];
                double value = (document['value'] as num?)?.toDouble() ?? 0.0;
                if (!map.containsKey(category)) {
                  map[category] = 0.0;
                }
                map[category] = map[category]! + value;
                return map;
              })
            : {};

  @override
  _MonthWidgetState createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          if (widget.documents.isEmpty)
            _noDataWidget()
          else ...[
            _expenses(),
            _graph(),
            Container(
              color: const Color.fromARGB(255, 71, 187, 172).withOpacity(0.15),
              height: 24.0,
            ),
            Expanded(child: _list()),
          ],
        ],
      ),
    );
  }

  Widget _noDataWidget() {
    return Container(
      height: 707,
      color: Colors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image.asset(
                'assets/undraw_Not_found_re_bh2e.png',
                height: 250,
                width: 300,
              ),
              const SizedBox(height: 20),
              const Text(
                'No data available',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text(
          "${widget.total.toStringAsFixed(2)}€",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
        const Text(
          "Total expenses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Color.fromARGB(255, 71, 187, 172),
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return SizedBox(
        height: 250.0,
        child: LinesGraphWidget(
          data: widget.perDay,
        ),
      );
    } else {
      var perCategory = widget.categories.keys
          .map((name) => widget.categories[name]! / widget.total)
          .toList();
      return SizedBox(
        height: 250.0,
        child: PieGraphWidget(
          data: perCategory,
        ),
      );
    }
  }

  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed("/details",
            arguments: DetailsParams(categoryName: name, month: widget.month));
      },
      leading: Icon(
        icon,
        size: 32.0,
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      subtitle: Text(
        "$percent% of expenses",
        style: const TextStyle(
          fontSize: 16.0,
          color: Color.fromARGB(255, 71, 187, 172),
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "$value €",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
      itemCount: widget.categories.keys.length,
      itemBuilder: (BuildContext context, int index) {
        var key = widget.categories.keys.elementAt(index);
        var data = widget.categories[key];
        return _item(
          FontAwesomeIcons.moneyBill,
          key,
          widget.total != 0 ? (100 * (data ?? 0.0) ~/ widget.total) : 0,
          data ?? 0.0,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.greenAccent.withOpacity(0.15),
          height: 8.0,
        );
      },
    );
  }
}
