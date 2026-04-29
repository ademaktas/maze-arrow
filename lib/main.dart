import 'package:flutter/material.dart';
import 'game.dart';
import 'level.dart';

void main() {
  runApp(const ArrowMazeApp());
}

class ArrowMazeApp extends StatelessWidget {
  const ArrowMazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int level = 1;
  int hearts = 3;
  late GameState game;

  @override
  void initState() {
    super.initState();
    game = LevelGen.generate(level);
  }

  IconData iconFor(Dir d) {
    switch (d) {
      case Dir.up:
        return Icons.arrow_upward;
      case Dir.down:
        return Icons.arrow_downward;
      case Dir.left:
        return Icons.arrow_back;
      case Dir.right:
        return Icons.arrow_forward;
    }
  }

  void nextLevel() {
    setState(() {
      level++;
      hearts = 3;
      game = LevelGen.generate(level);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = game.size;

    return Scaffold(
      appBar: AppBar(title: Text("Seviye $level")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text("❤️" * hearts, style: const TextStyle(fontSize: 24)),
          Expanded(
            child: GridView.builder(
              itemCount: size * size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
              ),
              itemBuilder: (_, i) {
                final x = i ~/ size;
                final y = i % size;
                final c = game.grid[x][y];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      final moved = game.tap(x, y);
                      if (!moved && hearts > 0) hearts--;
                      if (game.isCleared()) nextLevel();
                    });
                  },
                  child: Center(
                    child: c.active
                        ? Icon(iconFor(c.dir))
                        : const SizedBox(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
