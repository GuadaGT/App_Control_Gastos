import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatefulWidget {
  final Map<String, IconData> categories;

  const CategorySelectionWidget({super.key, required this.categories});

  @override
  _CategorySelectionWidgetState createState() =>
      _CategorySelectionWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;

  const CategoryWidget({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
    );
  }
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  String currentItem = "";

  List<Widget> _buildCategoryWidgets() {
    List<Widget> widgets = [];
    widget.categories.forEach((name, icon) {
      widgets.add(
        CategoryWidget(
          name: name,
          icon: icon,
        ),
      );
    });
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildCategoryWidgets(),
    );
  }
}
