import 'dart:async';

import 'package:flutter/material.dart';

class AmbientPomodoroRoom extends StatefulWidget {
  const AmbientPomodoroRoom({super.key});

  @override
  State<AmbientPomodoroRoom> createState() => _AmbientPomodoroRoomState();
}

class _AmbientPomodoroRoomState extends State<AmbientPomodoroRoom> {
  static const int workDuration = 25 * 60; // 25 minutes in seconds
  static const int breakDuration = 5 * 60; // 5 minutes in seconds

  int _timeLeft = workDuration;
  bool _isRunning = false;
  bool _isWorkMode = true;
  Timer? _timer;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _switchMode(); // Time's up, switch modes automatically
          }
        });
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _switchMode() {
    _timer?.cancel();
    setState(() {
      _isWorkMode = !_isWorkMode;
      _timeLeft = _isWorkMode ? workDuration : breakDuration;
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _timeLeft = _isWorkMode ? workDuration : breakDuration;
    });
  }

  // Converts raw seconds into a formatted MM:SS string
  String get _formattedTime {
    int minutes = _timeLeft ~/ 60;
    int seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Always clean up timers to prevent memory leaks!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isWorkMode
          ? const Color(0xFF1A1A2E)
          : const Color(0xFF16213E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isWorkMode ? 'Deep Work' : 'Break Time',
              style: TextStyle(
                fontSize: 24,
                color: _isWorkMode
                    ? Colors.deepPurpleAccent
                    : Colors.tealAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              _formattedTime,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'reset_btn',
                  backgroundColor: Colors.grey[800],
                  onPressed: _resetTimer,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton.large(
                  heroTag: 'play_pause_btn',
                  backgroundColor: _isWorkMode
                      ? Colors.deepPurpleAccent
                      : Colors.tealAccent,
                  onPressed: _toggleTimer,
                  child: Icon(
                    _isRunning ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'skip_btn',
                  backgroundColor: Colors.grey[800],
                  onPressed: _switchMode,
                  child: const Icon(Icons.skip_next, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
