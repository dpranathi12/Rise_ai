import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:rise_ai/features/alarm/domain/alarm_model.dart';
import 'package:rise_ai/features/home/presentation/pages/home_screen.dart';
import 'package:confetti/confetti.dart';

class AICameraScreen extends StatefulWidget {
  final AlarmModel alarm;

  const AICameraScreen({super.key, required this.alarm});

  @override
  State<AICameraScreen> createState() => _AICameraScreenState();
}

class _AICameraScreenState extends State<AICameraScreen> {
  CameraController? _controller;
  bool _isBusy = false;
  int _currentReps = 0;
  String _status = "Initializing AI...";
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller?.initialize();
    if (mounted) {
      setState(() {
        _status = "Position yourself in view";
      });
      // In a real app, we would start image stream and pass to ML Kit
      // _controller?.startImageStream(_processImage);
      
      // Simulation for demo purposes
      _simulateExercise();
    }
  }

  void _simulateExercise() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    setState(() => _status = "Ready! Start ${widget.alarm.exerciseType}");
    
    for (int i = 1; i <= widget.alarm.repetitions; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        _currentReps = i;
        _status = "Good form! Keep going.";
      });
    }
    
    setState(() => _status = "Challenge Completed!");
    _confettiController.play();
    
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          Center(
            child: CameraPreview(_controller!),
          ),
          
          // Overlay
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                _buildStatusIndicator(),
                const SizedBox(height: 24),
                _buildProgressIndicator(),
                const SizedBox(height: 40),
              ],
            ),
          ),
          
          // Confetti
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.alarm.exerciseType,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Target: ${widget.alarm.repetitions} reps",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "ALARM ACTIVE",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        _status,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_currentReps",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            " / ${widget.alarm.repetitions}",
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
