import 'package:flutter/material.dart';

// Represents a single continuous line drawn on the screen
class Stroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  Stroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });
}

class DoodleCanvas extends StatefulWidget {
  const DoodleCanvas({super.key});

  @override
  State<DoodleCanvas> createState() => _DoodleCanvasState();
}

class _DoodleCanvasState extends State<DoodleCanvas> {
  List<Stroke> _strokes = [];
  Stroke? _currentStroke;
  Color _selectedColor = Colors.white;
  double _strokeWidth = 5.0;

  // Available colors for the palette
  final List<Color> _colors = [
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  void _startStroke(DragStartDetails details) {
    setState(() {
      _currentStroke = Stroke(
        points: [details.localPosition],
        color: _selectedColor,
        strokeWidth: _strokeWidth,
      );
      _strokes.add(_currentStroke!);
    });
  }

  void _updateStroke(DragUpdateDetails details) {
    setState(() {
      _currentStroke?.points.add(details.localPosition);
    });
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: Column(
        children: [
          // The Drawing Area
          Expanded(
            child: GestureDetector(
              onPanStart: _startStroke,
              onPanUpdate: _updateStroke,
              child: ClipRect(
                // Prevents drawing from bleeding outside the canvas
                child: CustomPaint(
                  painter: DoodlePainter(strokes: _strokes),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          // The Toolbar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: const Color(0xFF2B2B3C),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed: _clearCanvas,
                  tooltip: 'Clear Canvas',
                ),
                // Generate color palette buttons
                ..._colors.map(
                  (color) => GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.grey
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// The painter that actually renders the strokes onto the screen
class DoodlePainter extends CustomPainter {
  final List<Stroke> strokes;

  DoodlePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Draw the line point by point
      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DoodlePainter oldDelegate) => true;
}
