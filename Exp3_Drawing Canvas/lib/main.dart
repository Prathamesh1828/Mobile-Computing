import 'package:flutter/material.dart';

void main() {
  runApp(const DrawingApp());
}

class DrawingApp extends StatelessWidget {
  const DrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
      ),
      home: const DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<List<DrawPoint>> strokes = [];
  List<List<DrawPoint>> undoneStrokes = [];

  Color selectedColor = Colors.black;
  double strokeWidth = 4.0;
  bool isEraser = false;
  bool isDotted = false;
  Color backgroundColor = const Color(0xFFF4F6FA);

  List<DrawPoint> currentStroke = [];

  void startStroke(Offset point) {
    currentStroke = [];
    addPoint(point);
  }

  void addPoint(Offset point) {
    currentStroke.add(
      DrawPoint(
        offset: point,
        paint: Paint()
          ..color = isEraser ? backgroundColor : selectedColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
      ),
    );
  }

  void endStroke() {
    strokes.add(List.from(currentStroke));
    undoneStrokes.clear();
  }

  void undo() {
    if (strokes.isNotEmpty) {
      setState(() {
        undoneStrokes.add(strokes.removeLast());
      });
    }
  }

  void redo() {
    if (undoneStrokes.isNotEmpty) {
      setState(() {
        strokes.add(undoneStrokes.removeLast());
      });
    }
  }

  void clearCanvas() {
    setState(() {
      strokes.clear();
      undoneStrokes.clear();
    });
  }

  Widget colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          isEraser = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }

  Widget backgroundButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          backgroundColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drawing Canvas"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E86FF), Color(0xFF6FB1FF)],
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: undo, icon: const Icon(Icons.undo)),
          IconButton(onPressed: redo, icon: const Icon(Icons.redo)),
          IconButton(onPressed: clearCanvas, icon: const Icon(Icons.delete)),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              startStroke(box.globalToLocal(details.globalPosition));
            },
            onPanUpdate: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              setState(() {
                addPoint(box.globalToLocal(details.globalPosition));
              });
            },
            onPanEnd: (details) {
              setState(() {
                endStroke();
              });
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: DrawingPainter(
                strokes: strokes,
                backgroundColor: backgroundColor,
                isDotted: isDotted,
              ),
            ),
          ),

          // Tool Panel
          Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Color Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      colorButton(Colors.black),
                      colorButton(Colors.red),
                      colorButton(Colors.blue),
                      colorButton(Colors.green),
                      colorButton(Colors.orange),
                      colorButton(Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Brush size
                  Row(
                    children: [
                      const Icon(Icons.brush),
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 20,
                          value: strokeWidth,
                          onChanged: (value) {
                            setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  // Tool buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isEraser = true;
                          });
                        },
                        icon: const Icon(Icons.auto_fix_high),
                        label: const Text("Eraser"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            isDotted = !isDotted;
                          });
                        },
                        icon: const Icon(Icons.blur_on),
                        label: const Text("Dotted"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Background picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      backgroundButton(Colors.white),
                      backgroundButton(Colors.yellow.shade100),
                      backgroundButton(Colors.blue.shade50),
                      backgroundButton(Colors.green.shade50),
                      backgroundButton(Colors.pink.shade50),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawPoint {
  final Offset offset;
  final Paint paint;

  DrawPoint({required this.offset, required this.paint});
}

class DrawingPainter extends CustomPainter {
  final List<List<DrawPoint>> strokes;
  final Color backgroundColor;
  final bool isDotted;

  DrawingPainter({
    required this.strokes,
    required this.backgroundColor,
    required this.isDotted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRect(Offset.zero & size, bgPaint);

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        if (isDotted) {
          canvas.drawCircle(
            stroke[i].offset,
            stroke[i].paint.strokeWidth / 2,
            stroke[i].paint,
          );
        } else {
          canvas.drawLine(
            stroke[i].offset,
            stroke[i + 1].offset,
            stroke[i].paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
