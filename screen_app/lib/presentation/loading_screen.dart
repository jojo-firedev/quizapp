import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key, this.infoText = 'Lädt...'});

  final String infoText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(infoText),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          windowManager.setFullScreen(true);
          windowManager.setAlwaysOnTop(true);
        },
        icon: const Icon(Icons.fullscreen),
        label: const Text('Vollbild'),
      ),
    );
  }
}
