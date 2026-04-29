import 'game.dart';

class LevelGen {
  static int sizeForLevel(int level) {
    if (level < 20) return 5;
    if (level < 60) return 6;
    if (level < 120) return 7;
    if (level < 300) return 8;
    if (level < 600) return 9;
    return 10;
  }

  static int minEdgeOpenings(int level) {
    if (level % 100 == 0) return 1; // çok zor
    if (level % 50 == 0) return 2;  // zor
    if (level < 30) return 6;
    if (level < 80) return 4;
    return 3;
  }

  static GameState generate(int level) {
    final size = sizeForLevel(level);
    final minOpen = minEdgeOpenings(level);

    while (true) {
      final game = GameState(size);
      int openings = 0;

      for (int i = 0; i < game.size; i++) {
        for (int j = 0; j < game.size; j++) {
          final (nx, ny) = game.next(i, j);
          if (!game.inBounds(nx, ny)) {
            openings++;
          }
        }
      }

      if (openings >= minOpen) {
        return game;
      }
    }
  }
}
