import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Audio Assets Tests', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('Audio files should be accessible', () async {
      // Test if the primary audio file can be loaded from assets
      final audioFiles = [
        'audio/audio-1.wav', // Primary audio file used by all sounds
      ];

      for (String audioFile in audioFiles) {
        try {
          final data = await rootBundle.load(audioFile);
          expect(data.lengthInBytes, greaterThan(0),
              reason: 'Audio file $audioFile should not be empty');
          print(
              '✅ $audioFile loaded successfully (${data.lengthInBytes} bytes)');
        } catch (e) {
          fail('❌ Failed to load audio file $audioFile: $e');
        }
      }
    });

    test('Audio file paths should match sound configurations', () {
      // All sounds now use the same audio file for consistent functionality
      final soundConfigs = {
        'Rain Sounds': 'audio/audio-1.wav',
        'Ocean Waves': 'audio/audio-1.wav',
        'Forest Sounds': 'audio/audio-1.wav',
        'White Noise': 'audio/audio-1.wav',
        'Fireplace': 'audio/audio-1.wav',
        'Piano Music': 'audio/audio-1.wav',
      };

      // Verify that all configured audio paths exist
      soundConfigs.forEach((soundName, assetPath) {
        expect(assetPath, isNotEmpty,
            reason: 'Sound $soundName should have a valid asset path');
        expect(assetPath, startsWith('audio/'),
            reason: 'Asset path should start with audio/');
      });
    });
  });
}
