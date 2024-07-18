import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieGraphWidget extends StatefulWidget {
  final List<double> data;
  const PieGraphWidget({super.key, required this.data});

  @override
  State<PieGraphWidget> createState() => _PieGraphWidgetState();
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  List<charts.Color> _generateGreenShades(int count) {
    final List<charts.Color> shades = [];
    for (int i = 0; i < count; i++) {
      double opacity = 0.3 + (i / (count - 1)) * 0.7;
      final shade = charts.ColorUtil.fromDartColor(
          const Color.fromARGB(255, 71, 187, 172).withOpacity(opacity));
      shades.add(shade);
    }
    return shades;
  }

  @override
  Widget build(BuildContext context) {
    final shades = _generateGreenShades(widget.data.length);
    List<charts.Series<double, int>> series = [
      charts.Series<double, int>(
        id: 'Gasto',
        colorFn: (_, index) => shades[index ?? 0],
        domainFn: (value, index) => index ?? 0,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];
    return charts.PieChart(series);
  }
}

class LinesGraphWidget extends StatefulWidget {
  final List<double> data;

  const LinesGraphWidget({super.key, required this.data});

  @override
  _LinesGraphWidgetState createState() => _LinesGraphWidgetState();
}

class _LinesGraphWidgetState extends State<LinesGraphWidget> {
  void _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      for (var datumPair in selectedDatum) {
        measures[datumPair.series.displayName ?? ''] =
            datumPair.datum as double;
      }
    }
    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<double, int>> series = [
      charts.Series<double, int>(
        id: 'Gasto',
        colorFn: (_, __) => const charts.Color(
          r: 71,
          g: 187,
          b: 172,
          a: 255,
        ),
        domainFn: (value, index) => index ?? 0,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return charts.LineChart(
      series,
      animate: false,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          [
            charts.TickSpec(0, label: '01'),
            charts.TickSpec(4, label: '05'),
            charts.TickSpec(9, label: '10'),
            charts.TickSpec(14, label: '15'),
            charts.TickSpec(19, label: '20'),
            charts.TickSpec(24, label: '25'),
            charts.TickSpec(29, label: '30'),
          ],
        ),
      ),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 4,
        ),
      ),
    );
  }
}
