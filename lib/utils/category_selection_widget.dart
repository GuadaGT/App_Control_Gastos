import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) valueChanged;

  const CategorySelectionWidget(
      {super.key, required this.categories, required this.valueChanged});

  @override
  _CategorySelectionWidgetState createState() =>
      _CategorySelectionWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget(
      {super.key,
      required this.name,
      required this.icon,
      required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color: selected
                        ? const Color.fromARGB(255, 186, 105, 240)
                        : Colors.grey,
                    width: selected ? 3.0 : 1.0)),
            child: Icon(icon),
          ),
          Text(name)
        ],
      ),
    );
  }
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  String currentItem = "";

  List<Widget> _buildCategoryWidgets() {
    List<Widget> widgets = [];
    widget.categories.forEach((name, icon) {
      widgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              currentItem = name;
            });
            widget.valueChanged(name);
          },
          child: CategoryWidget(
            name: name,
            icon: icon,
            selected: name == currentItem,
          ),
        ),
      );
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: _buildCategoryWidgets(),
    );
  }
}
