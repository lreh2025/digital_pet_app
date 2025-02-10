import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DrawingApp(),
    );
  }
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({super.key});

  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  List<List<Offset>> lines = [];
  bool isSmileySelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isSmileySelected = !isSmileySelected;
                });
              },
              child: Text(isSmileySelected ? 'Draw Lines' : 'Draw Smiley Face'),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (!isSmileySelected) {
                  setState(() {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final localPosition =
                        renderBox.globalToLocal(details.globalPosition);

                    if (lines.isEmpty || lines.last.isEmpty) {
                      lines.add([localPosition]);
                    } else {
                      lines.last.add(localPosition);
                    }
                  });
                }
              },
              onPanEnd: (_) {
                if (!isSmileySelected) {
                  setState(() {
                    lines.add([]);
                  });
                }
              },
              child: CustomPaint(
                painter: MyPainter(lines, isSmileySelected),
                size: Size.infinite,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            lines.clear();
            isSmileySelected = false;
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final bool isSmileySelected;

  MyPainter(this.lines, this.isSmileySelected);

  @override
  void paint(Canvas canvas, Size size) {
    if (isSmileySelected) {
      _drawSmileyFace(canvas);
    } else {
      _drawLines(canvas);
    }
  }

  void _drawSmileyFace(Canvas canvas) {
    Paint paintFace = Paint()..color = Colors.yellow;
    Paint paintEyes = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill; // Make eyes filled circles
    Paint paintSmile = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Round and thicker smile

    // Face
    canvas.drawCircle(Offset(150, 150), 100, paintFace);

    // Eyes (adjust positions and sizes)
    canvas.drawOval(
        Rect.fromCenter(center: Offset(110, 120), width: 25, height: 30),
        paintEyes);
    canvas.drawOval(
        Rect.fromCenter(center: Offset(190, 120), width: 25, height: 30),
        paintEyes);

    // Smile (Draw a semi-oval for a curved smile)
    Path smilePath = Path();
    smilePath.addArc(Rect.fromCircle(center: Offset(150, 170), radius: 60), 0,
        3.14); // Use a full PI (3.14) for a semi-circle
    canvas.drawPath(smilePath, paintSmile);
  }

  void _drawLines(Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (final line in lines) {
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(line[i], line[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
