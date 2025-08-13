import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/components/modern_bottom_nav.dart';
import 'package:myapp/breathing_exercise_screen.dart';
import 'package:myapp/sound_player_screen.dart';

class MeditationScreen extends StatefulWidget {
  final String userId;

  const MeditationScreen({super.key, required this.userId});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWithBottomNav(
      currentIndex: 3, // Meditation tab index
      userId: widget.userId,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Meditation & Wellness',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF6B73FF),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Breathing'),
              Tab(text: 'Sounds'),
              Tab(text: 'Sleep Stories'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBreathingTab(),
            _buildSoundsTab(),
            _buildSleepStoriesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBreathingExerciseCard(
            'Box Breathing',
            'Inhale for 4, hold for 4, exhale for 4, hold for 4',
            Icons.crop_square_rounded,
            const Color(0xFF4CAF50),
            () => _startBreathingExercise('box'),
          ),
          const SizedBox(height: 16),
          _buildBreathingExerciseCard(
            '4-7-8 Breathing',
            'Inhale for 4, hold for 7, exhale for 8',
            Icons.air_rounded,
            const Color(0xFF2196F3),
            () => _startBreathingExercise('478'),
          ),
          const SizedBox(height: 16),
          _buildBreathingExerciseCard(
            'Deep Breathing',
            'Slow, deep breaths to calm your mind',
            Icons.spa_rounded,
            const Color(0xFF9C27B0),
            () => _startBreathingExercise('deep'),
          ),
          const SizedBox(height: 16),
          _buildBreathingExerciseCard(
            'Quick Calm',
            '2-minute breathing exercise for instant calm',
            Icons.flash_on_rounded,
            const Color(0xFFFF9800),
            () => _startBreathingExercise('quick'),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingExerciseCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.play_arrow, color: color, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoundsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSoundCard('Rain Sounds', 'Gentle rain for relaxation',
              Icons.grain, const Color(0xFF607D8B)),
          const SizedBox(height: 16),
          _buildSoundCard('Ocean Waves', 'Calming ocean sounds', Icons.waves,
              const Color(0xFF2196F3)),
          const SizedBox(height: 16),
          _buildSoundCard('Forest Sounds', 'Birds and nature sounds',
              Icons.park, const Color(0xFF4CAF50)),
          const SizedBox(height: 16),
          _buildSoundCard('White Noise', 'Consistent background noise',
              Icons.volume_up, const Color(0xFF9E9E9E)),
          const SizedBox(height: 16),
          _buildSoundCard('Fireplace', 'Crackling fire sounds',
              Icons.local_fire_department, const Color(0xFFFF5722)),
          const SizedBox(height: 16),
          _buildSoundCard('Piano Music', 'Soft piano melodies', Icons.piano,
              const Color(0xFF795548)),
        ],
      ),
    );
  }

  Widget _buildSoundCard(
      String title, String description, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _playSound(title),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon, color: Colors.white, size: 25),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.play_circle_filled, color: color, size: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepStoriesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStoryCard(
            'Peaceful Garden',
            'A journey through a serene garden',
            '15 min',
            Icons.local_florist,
            const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 16),
          _buildStoryCard(
            'Mountain Lake',
            'Relaxing by a calm mountain lake',
            '20 min',
            Icons.landscape,
            const Color(0xFF2196F3),
          ),
          const SizedBox(height: 16),
          _buildStoryCard(
            'Starry Night',
            'Gazing at stars on a peaceful night',
            '25 min',
            Icons.nights_stay,
            const Color(0xFF3F51B5),
          ),
          const SizedBox(height: 16),
          _buildStoryCard(
            'Forest Walk',
            'A gentle walk through the woods',
            '18 min',
            Icons.forest,
            const Color(0xFF8BC34A),
          ),
          const SizedBox(height: 16),
          _buildStoryCard(
            'Beach Sunset',
            'Watching the sunset by the ocean',
            '22 min',
            Icons.beach_access,
            const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(
    String title,
    String description,
    String duration,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _playStory(title),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(icon, color: Colors.white, size: 25),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(Icons.play_circle_filled, color: color, size: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startBreathingExercise(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExerciseScreen(
          exerciseType: type,
          userId: widget.userId,
        ),
      ),
    );
  }

  void _playSound(String soundName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SoundPlayerScreen(
          soundName: soundName,
          userId: widget.userId,
        ),
      ),
    );
  }

  void _playStory(String storyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.auto_stories, color: Color(0xFF2196F3)),
            const SizedBox(width: 8),
            Text(storyName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.bedtime,
                    size: 64,
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    storyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Close your eyes and let this peaceful story guide you to sleep...',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const LinearProgressIndicator(
                    value: 0.3,
                    backgroundColor: Colors.grey,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '5:30 / 18:00',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
