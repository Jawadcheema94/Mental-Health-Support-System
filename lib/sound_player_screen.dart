import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class SoundPlayerScreen extends StatefulWidget {
  final String soundName;
  final String userId;

  const SoundPlayerScreen({
    super.key,
    required this.soundName,
    required this.userId,
  });

  @override
  State<SoundPlayerScreen> createState() => _SoundPlayerScreenState();
}

class _SoundPlayerScreenState extends State<SoundPlayerScreen>
    with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Timer? _timer;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  // Sound configurations with local audio assets
  // All sounds use the same audio file to ensure consistent functionality
  Map<String, Map<String, dynamic>> _soundConfigs = {
    'Rain Sounds': {
      'color': Color(0xFF607D8B),
      'icon': Icons.grain,
      'description': 'Gentle rain drops for deep relaxation',
      'duration': Duration(minutes: 30),
      'asset': 'audio/audio-1.wav',
    },
    'Ocean Waves': {
      'color': Color(0xFF2196F3),
      'icon': Icons.waves,
      'description': 'Calming ocean waves washing ashore',
      'duration': Duration(minutes: 45),
      'asset': 'audio/audio-1.wav',
    },
    'Forest Sounds': {
      'color': Color(0xFF4CAF50),
      'icon': Icons.park,
      'description': 'Birds chirping in a peaceful forest',
      'duration': Duration(minutes: 35),
      'asset': 'audio/audio-1.wav',
    },
    'White Noise': {
      'color': Color(0xFF9E9E9E),
      'icon': Icons.volume_up,
      'description': 'Consistent background noise for focus',
      'duration': Duration(minutes: 60),
      'asset': 'audio/audio-1.wav',
    },
    'Fireplace': {
      'color': Color(0xFFFF5722),
      'icon': Icons.local_fire_department,
      'description': 'Crackling fire sounds for warmth',
      'duration': Duration(minutes: 40),
      'asset': 'audio/audio-1.wav',
    },
    'Piano Music': {
      'color': Color(0xFF795548),
      'icon': Icons.piano,
      'description': 'Soft piano melodies for tranquility',
      'duration': Duration(minutes: 25),
      'asset': 'audio/audio-1.wav',
    },
  };

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    final config = _soundConfigs[widget.soundName]!;
    _duration = config['duration'];

    // Set up audio player listeners
    _setupAudioPlayer();

    // Start the playback
    _startPlayback();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      // Loop the audio when it completes
      if (_isPlaying && !_isPaused) {
        _startPlayback();
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
        _isPaused = state == PlayerState.paused;
      });
    });
  }

  void _startPlayback() async {
    try {
      final config = _soundConfigs[widget.soundName]!;
      final audioAsset = config['asset'] as String;

      setState(() {
        _isPlaying = true;
        _isPaused = false;
      });

      _waveController.repeat(reverse: true);

      // Stop any currently playing audio first
      await _audioPlayer.stop();

      // Play the local audio asset
      print('Attempting to play audio from asset: $audioAsset');
      await _audioPlayer.play(AssetSource(audioAsset));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎵 Playing ${widget.soundName}'),
          duration: Duration(seconds: 2),
          backgroundColor: config['color'],
        ),
      );

      print('Successfully started playing: $audioAsset');
    } catch (e) {
      print('Error playing audio: $e');

      // Show error feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Audio file not found. Using simulation mode.'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.orange,
        ),
      );

      // Fallback to simulation if audio fails
      _simulatePlayback();
    }
  }

  void _simulatePlayback() {
    // Fallback simulation if real audio fails
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying && !_isPaused) {
        setState(() {
          _position = Duration(seconds: _position.inSeconds + 1);
          if (_position >= _duration) {
            _stopPlayback();
          }
        });
      }
    });
  }

  void _pausePlayback() async {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      await _audioPlayer.pause();
      _waveController.stop();
    } else {
      await _audioPlayer.resume();
      _waveController.repeat(reverse: true);
    }
  }

  void _stopPlayback() async {
    setState(() {
      _isPlaying = false;
      _isPaused = false;
      _position = Duration.zero;
    });

    await _audioPlayer.stop();
    _timer?.cancel();
    _waveController.stop();
    _waveController.reset();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final config = _soundConfigs[widget.soundName]!;
    final soundColor = config['color'] as Color;
    final soundIcon = config['icon'] as IconData;
    final description = config['description'] as String;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.soundName,
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
              soundColor.withOpacity(0.3),
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sound visualization
              AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return Container(
                    width: 200 + (_waveAnimation.value * 50),
                    height: 200 + (_waveAnimation.value * 50),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: soundColor
                            .withOpacity(0.5 + _waveAnimation.value * 0.5),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: soundColor.withOpacity(0.3),
                          blurRadius: 30 + (_waveAnimation.value * 20),
                          spreadRadius: 10 + (_waveAnimation.value * 10),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: soundColor.withOpacity(0.1),
                      ),
                      child: Center(
                        child: Icon(
                          soundIcon,
                          color: soundColor,
                          size: 80,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Sound name and description
              Text(
                widget.soundName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: soundColor,
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: _duration.inSeconds > 0
                          ? _position.inSeconds / _duration.inSeconds
                          : 0,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(soundColor),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Stop button
                  GestureDetector(
                    onTap: _stopPlayback,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.stop,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),

                  // Play/Pause button
                  GestureDetector(
                    onTap: _isPlaying ? _pausePlayback : _startPlayback,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: soundColor,
                        boxShadow: [
                          BoxShadow(
                            color: soundColor.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),

                  // Volume button (placeholder)
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Volume control coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Status text
              Text(
                _isPlaying ? (_isPaused ? 'Paused' : 'Playing...') : 'Stopped',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
