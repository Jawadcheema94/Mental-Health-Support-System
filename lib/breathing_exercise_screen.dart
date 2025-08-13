import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:myapp/theme/app_theme.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final String exerciseType;
  final String userId;

  const BreathingExerciseScreen({
    super.key,
    required this.exerciseType,
    required this.userId,
  });

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _circleController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _circleAnimation;
  
  Timer? _timer;
  Timer? _phaseTimer;
  
  bool _isActive = false;
  int _currentPhase = 0; // 0: inhale, 1: hold, 2: exhale, 3: hold
  String _currentInstruction = 'Tap to start';
  int _cycleCount = 0;
  int _totalTime = 0;
  
  // Exercise configurations
  Map<String, Map<String, dynamic>> _exercises = {
    'box': {
      'name': 'Box Breathing',
      'phases': [4, 4, 4, 4], // inhale, hold, exhale, hold
      'instructions': ['Inhale', 'Hold', 'Exhale', 'Hold'],
      'color': Color(0xFF4CAF50),
    },
    '478': {
      'name': '4-7-8 Breathing',
      'phases': [4, 7, 8, 0], // inhale, hold, exhale, no hold
      'instructions': ['Inhale', 'Hold', 'Exhale', ''],
      'color': Color(0xFF2196F3),
    },
    'deep': {
      'name': 'Deep Breathing',
      'phases': [6, 2, 6, 2], // inhale, hold, exhale, hold
      'instructions': ['Breathe In', 'Hold', 'Breathe Out', 'Hold'],
      'color': Color(0xFF9C27B0),
    },
    'quick': {
      'name': 'Quick Calm',
      'phases': [3, 1, 3, 1], // inhale, hold, exhale, hold
      'instructions': ['Inhale', 'Hold', 'Exhale', 'Hold'],
      'color': Color(0xFFFF9800),
    },
  };

  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _circleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _circleAnimation = Tween<double>(
      begin: 100,
      end: 150,
    ).animate(CurvedAnimation(
      parent: _circleController,
      curve: Curves.easeInOut,
    ));
  }

  void _startExercise() {
    if (_isActive) {
      _stopExercise();
      return;
    }
    
    setState(() {
      _isActive = true;
      _currentPhase = 0;
      _cycleCount = 0;
      _totalTime = 0;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _totalTime++;
      });
    });
    
    _nextPhase();
  }
  
  void _stopExercise() {
    setState(() {
      _isActive = false;
      _currentInstruction = 'Tap to start';
    });
    
    _timer?.cancel();
    _phaseTimer?.cancel();
    _breathingController.reset();
    _circleController.reset();
  }
  
  void _nextPhase() {
    if (!_isActive) return;
    
    final exercise = _exercises[widget.exerciseType]!;
    final phases = exercise['phases'] as List<int>;
    final instructions = exercise['instructions'] as List<String>;
    
    if (_currentPhase >= phases.length) {
      _currentPhase = 0;
      _cycleCount++;
    }
    
    final phaseDuration = phases[_currentPhase];
    final instruction = instructions[_currentPhase];
    
    if (phaseDuration == 0 || instruction.isEmpty) {
      _currentPhase++;
      _nextPhase();
      return;
    }
    
    setState(() {
      _currentInstruction = instruction;
    });
    
    // Animate based on phase
    if (_currentPhase == 0) { // Inhale
      _breathingController.forward();
      _circleController.forward();
    } else if (_currentPhase == 2) { // Exhale
      _breathingController.reverse();
      _circleController.reverse();
    }
    
    _breathingController.duration = Duration(seconds: phaseDuration);
    _circleController.duration = Duration(seconds: phaseDuration);
    
    _phaseTimer = Timer(Duration(seconds: phaseDuration), () {
      _currentPhase++;
      _nextPhase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercises[widget.exerciseType]!;
    final exerciseName = exercise['name'] as String;
    final exerciseColor = exercise['color'] as Color;
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          exerciseName,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              exerciseColor.withOpacity(0.3),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Breathing circle animation
              AnimatedBuilder(
                animation: _circleAnimation,
                builder: (context, child) {
                  return Container(
                    width: _circleAnimation.value,
                    height: _circleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: exerciseColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: exerciseColor.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: AnimatedBuilder(
                      animation: _breathingAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _breathingAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: exerciseColor.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.spa,
                                color: exerciseColor,
                                size: 40,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 60),
              
              // Instruction text
              Text(
                _currentInstruction,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: exerciseColor,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Stats
              if (_isActive) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('Cycles', _cycleCount.toString(), exerciseColor),
                    _buildStat('Time', '${_totalTime}s', exerciseColor),
                  ],
                ),
                const SizedBox(height: 40),
              ],
              
              // Start/Stop button
              GestureDetector(
                onTap: _startExercise,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: exerciseColor,
                    boxShadow: [
                      BoxShadow(
                        color: exerciseColor.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isActive ? Icons.stop : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Instructions
              if (!_isActive)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Find a comfortable position and tap the button to begin your breathing exercise.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phaseTimer?.cancel();
    _breathingController.dispose();
    _circleController.dispose();
    super.dispose();
  }
}
