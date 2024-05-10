import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Audrey Art is a digital art Company specialized in bringing art to life, we run your music cover art,personal potrait, character design,thumbnail sketches,2D Wallpaper Animation,tutorial and lot more.',
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
