import 'package:flutter/material.dart';
import 'vocabulary_list_screen.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VocabularyListScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E8EDE), Color(0xFF7EC8E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon (người học)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                // Text Welcome
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Welcome to English Learning App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tap anywhere to start',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
