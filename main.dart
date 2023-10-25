import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String stockSymbol = 'PG';
  bool showCircles = false;
  List<double> prices = [100, 110, 105, 120, 115];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Harga Saham $stockSymbol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Kode Saham: $stockSymbol'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final randomPrice =
                    (100 + (50 * (DateTime.now().second / 60))).toDouble();
                setState(() {
                  prices.add(randomPrice);
                });
              },
              child: Text('Refresh Data'),
            ),
            SizedBox(height: 20),
            Container(
              width: 300, 
              height: 200, 
              child: CustomPaint(
                size: Size(300, 200),
                painter: LineChartPainter(prices),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> prices;

  LineChartPainter(this.prices);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;

    final path = Path();
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final yScale = size.height / (maxY - minY);

    for (var i = 0; i < prices.length; i++) {
      final x = i * (size.width / (prices.length - 1));
      final y = size.height - ((prices[i] - minY) * yScale);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
