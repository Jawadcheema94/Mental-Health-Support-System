import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class VideoCallScreen extends StatefulWidget {
  final String meetingLink;
  final String therapistName;
  final String userId;

  const VideoCallScreen({
    super.key,
    required this.meetingLink,
    required this.therapistName,
    required this.userId,
  });

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool isMuted = false;
  bool isVideoOn = true;
  bool isCallActive = true;
  Timer? _callTimer;
  int _callDuration = 0;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
    // Set orientation to landscape for better video experience
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    // Here you would integrate with actual video calling SDK
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isMuted ? 'Microphone muted' : 'Microphone unmuted'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _toggleVideo() {
    setState(() {
      isVideoOn = !isVideoOn;
    });
    // Here you would integrate with actual video calling SDK
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isVideoOn ? 'Camera turned on' : 'Camera turned off'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _endCall() {
    setState(() {
      isCallActive = false;
    });
    _callTimer?.cancel();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Call Ended'),
          content: Text(
            'Your session with ${widget.therapistName} has ended.\nDuration: ${_formatDuration(_callDuration)}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _copyMeetingLink() {
    Clipboard.setData(ClipboardData(text: widget.meetingLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meeting link copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main video area
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1a1a1a),
                    Color(0xFF2d2d2d),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Therapist video placeholder
                  Container(
                    width: isSmallScreen ? 200 : 300,
                    height: isSmallScreen ? 150 : 225,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: isSmallScreen ? 30 : 40,
                          backgroundColor: Colors.purple,
                          child: Text(
                            widget.therapistName.isNotEmpty 
                                ? widget.therapistName[0].toUpperCase()
                                : 'T',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 24 : 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.therapistName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCallActive ? 'Connected' : 'Disconnected',
                          style: TextStyle(
                            color: isCallActive ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Call duration
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatDuration(_callDuration),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Top bar with meeting info
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.video_call, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Video Session with ${widget.therapistName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _copyMeetingLink,
                      icon: const Icon(Icons.copy, color: Colors.white, size: 20),
                      tooltip: 'Copy meeting link',
                    ),
                  ],
                ),
              ),
            ),
            
            // User video (small overlay)
            Positioned(
              top: 80,
              right: 16,
              child: Container(
                width: isSmallScreen ? 80 : 120,
                height: isSmallScreen ? 60 : 90,
                decoration: BoxDecoration(
                  color: isVideoOn ? Colors.grey[700] : Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: isVideoOn
                    ? const Center(
                        child: Text(
                          'You',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.videocam_off,
                          color: Colors.white54,
                          size: 20,
                        ),
                      ),
              ),
            ),
            
            // Bottom control bar
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute button
                    _buildControlButton(
                      icon: isMuted ? Icons.mic_off : Icons.mic,
                      onPressed: _toggleMute,
                      backgroundColor: isMuted ? Colors.red : Colors.grey[700]!,
                    ),
                    
                    // Video toggle button
                    _buildControlButton(
                      icon: isVideoOn ? Icons.videocam : Icons.videocam_off,
                      onPressed: _toggleVideo,
                      backgroundColor: isVideoOn ? Colors.grey[700]! : Colors.red,
                    ),
                    
                    // End call button
                    _buildControlButton(
                      icon: Icons.call_end,
                      onPressed: _endCall,
                      backgroundColor: Colors.red,
                      isLarge: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    bool isLarge = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isLarge ? 60 : 50,
        height: isLarge ? 60 : 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: isLarge ? 30 : 24,
        ),
      ),
    );
  }
}
