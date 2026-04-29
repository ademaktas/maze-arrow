import 'dart:math';

enum Dir { up, down, left, right }

class Cell {
  Dir dir;
  bool active;

  Cell(this.dir, {this.active = true});
}

class GameState {
  final int size;
  late List<List<Cell>> grid;

  GameState(this.size) {
    final rand = Random();
    grid = List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => Cell(Dir.values[rand.nextInt(4)]),
      ),
    );
  }

  bool inBounds(int x, int y) {
    return x >= 0 && y >= 0 && x < size && y < size;
  }

  (int, int) next(int x, int y) {
    switch (grid[x][y].dir) {
      case Dir.up:
        return (x - 1, y);
      case Dir.down:
        return (x + 1, y);
      case Dir.left:
        return (x, y - 1);
      case Dir.right:
        return (x, y + 1);
    }
  }

  bool tap(int x, int y) {
    if (!grid[x][y].active) return false;

    final (nx, ny) = next(x, y);

    if (!inBounds(nx, ny) || !grid[nx][ny].active) {
      grid[x][y].active = false;
      resolve();
      return true;
    }

    return false;
  }

  void resolve() {
    bool changed = true;

    while (changed) {
      changed = false;

      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          if (!grid[i][j].active) continue;

          final (nx, ny) = next(i, j);

          if (!inBounds(nx, ny) || !grid[nx][ny].active) {
            grid[i][j].active = false;
            changed = true;
          }
        }
      }
    }
  }

  bool isCleared() {
    for (var row in grid) {
      for (var cell in row) {
        if (cell.active) return false;
      }
    }
    return true;
  }
}
