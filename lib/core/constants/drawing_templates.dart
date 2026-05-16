import '../../models/painting_progress.dart';
import '../l10n/app_localizations.dart';

/// Các template lineart cho mini game vẽ tranh
/// User sẽ dùng các outline này làm cơ sở để tô màu
class DrawingTemplates {
  // Get localized templates
  static List<Painting> getTemplates(AppLocalizations l10n) {
    return [
      Painting(
        name: l10n.templateFlower,
        createdAt: DateTime(2024, 1, 1),
        pixels: _flowerTemplate,
      ),
      Painting(
        name: l10n.templateApple,
        createdAt: DateTime(2024, 1, 1),
        pixels: _appleTemplate,
      ),
      Painting(
        name: l10n.templateTree,
        createdAt: DateTime(2024, 1, 1),
        pixels: _treeTemplate,
      ),
      Painting(
        name: l10n.templateCat,
        createdAt: DateTime(2024, 1, 1),
        pixels: _catTemplate,
      ),
      Painting(
        name: l10n.templateSun,
        createdAt: DateTime(2024, 1, 1),
        pixels: _sunTemplate,
      ),
      Painting(
        name: l10n.templateButterfly,
        createdAt: DateTime(2024, 1, 1),
        pixels: _butterflyTemplate,
      ),
      Painting(
        name: l10n.templateFish,
        createdAt: DateTime(2024, 1, 1),
        pixels: _fishTemplate,
      ),
      Painting(
        name: l10n.templateHouse,
        createdAt: DateTime(2024, 1, 1),
        pixels: _houseTemplate,
      ),
    ];
  }

  // Empty cell constant
  static const int _empty = -1;

  // Colors from DrawingPalette (by index)
  static const int _black = 25; // '#181425'
  static const int _darkRed = 7; // '#a22633'
  static const int _darkYellow = 12; // '#feae34'
  static const int _darkGreen = 14; // '#265c42'
  static const int _darkBrown = 6; // '#733e39'

  // Template 1: Flower (Hoa đơn giản)
  static final List<List<int>> _flowerTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Flower center at (16, 12)
      // Center circle
      if (row >= 10 && row <= 14 && col >= 14 && col <= 18) {
        if ((row == 10 || row == 14) && (col >= 15 && col <= 17)) return _darkYellow;
        if ((row == 11 || row == 13) && (col == 14 || col == 18)) return _darkYellow;
        if (row == 12 && (col == 14 || col == 18)) return _darkYellow;
      }

      // Top petal
      if (row >= 6 && row <= 9 && col >= 14 && col <= 18) {
        if (row == 6 && (col == 15 || col == 16 || col == 17)) return _darkYellow;
        if (row == 7 && (col == 14 || col == 18)) return _darkYellow;
        if (row == 8 && (col == 14 || col == 18)) return _darkYellow;
        if (row == 9 && (col == 15 || col == 17)) return _darkYellow;
      }

      // Bottom petal
      if (row >= 15 && row <= 18 && col >= 14 && col <= 18) {
        if (row == 15 && (col == 15 || col == 17)) return _darkYellow;
        if (row == 16 && (col == 14 || col == 18)) return _darkYellow;
        if (row == 17 && (col == 14 || col == 18)) return _darkYellow;
        if (row == 18 && (col == 15 || col == 16 || col == 17)) return _darkYellow;
      }

      // Left petal
      if (row >= 10 && row <= 14 && col >= 10 && col <= 13) {
        if (col == 10 && (row == 11 || row == 12 || row == 13)) return _darkYellow;
        if (col == 11 && (row == 10 || row == 14)) return _darkYellow;
        if (col == 12 && (row == 10 || row == 14)) return _darkYellow;
        if (col == 13 && (row == 11 || row == 13)) return _darkYellow;
      }

      // Right petal
      if (row >= 10 && row <= 14 && col >= 19 && col <= 22) {
        if (col == 22 && (row == 11 || row == 12 || row == 13)) return _darkYellow;
        if (col == 21 && (row == 10 || row == 14)) return _darkYellow;
        if (col == 20 && (row == 10 || row == 14)) return _darkYellow;
        if (col == 19 && (row == 11 || row == 13)) return _darkYellow;
      }

      // Stem
      if (col == 16 && row >= 19 && row <= 28) return _darkGreen;

      // Leaves
      if (row == 22 && (col >= 13 && col <= 15)) return _darkGreen;
      if (row == 23 && col == 12) return _darkGreen;
      if (row == 24 && col == 11) return _darkGreen;

      if (row == 24 && (col >= 17 && col <= 19)) return _darkGreen;
      if (row == 25 && col == 20) return _darkGreen;
      if (row == 26 && col == 21) return _darkGreen;

      return _empty;
    });
  });

  // Template 2: Apple (Quả táo)
  static final List<List<int>> _appleTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Apple body (rounded shape)
      if (row >= 10 && row <= 25 && col >= 8 && col <= 24) {
        if (row == 10) {
          if ((col >= 10 && col <= 13) || (col >= 19 && col <= 22)) return _darkRed;
        }
        if (row == 11) {
          if (col == 9 || col == 14 || col == 18 || col == 23) return _darkRed;
        }
        if (row == 12) {
          if (col == 8 || col == 24) return _darkRed;
        }
        if (row >= 13 && row <= 19) {
          if (col == 8 || col == 24) return _darkRed;
        }
        if (row == 20) {
          if (col == 9 || col == 23) return _darkRed;
        }
        if (row == 21) {
          if (col == 10 || col == 22) return _darkRed;
        }
        if (row == 22) {
          if (col == 11 || col == 21) return _darkRed;
        }
        if (row == 23) {
          if (col == 13 || col == 19) return _darkRed;
        }
        if (row == 24) {
          if (col == 14 || col == 18) return _darkRed;
        }
        if (row == 25) {
          if (col >= 15 && col <= 17) return _darkRed;
        }
      }

      // Stem (cuống)
      if (col >= 15 && col <= 17) {
        if (row >= 6 && row <= 11) {
          if (col == 15 || col == 17) return _darkBrown;
          if (row == 6 || row == 11) return _darkBrown;
        }
      }

      // Leaf (lá)
      if (row >= 5 && row <= 9 && col >= 18 && col <= 23) {
        if (row == 5 && (col == 20 || col == 21)) return _darkGreen;
        if (row == 6 && (col == 19 || col == 22)) return _darkGreen;
        if (row == 7 && (col == 18 || col == 23)) return _darkGreen;
        if (row == 8 && (col == 19 || col == 22)) return _darkGreen;
        if (row == 9 && (col == 20 || col == 21)) return _darkGreen;
      }

      return _empty;
    });
  });

  // Template 3: Tree (Cây)
  static final List<List<int>> _treeTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Tree trunk
      if (col >= 14 && col <= 18 && row >= 20 && row <= 28) {
        if (col == 14 || col == 18) return _darkBrown;
        if (row == 20 || row == 28) return _darkBrown;
      }

      // Tree crown (circular-ish)
      if (row >= 6 && row <= 20 && col >= 8 && col <= 24) {
        if (row == 6 && (col >= 14 && col <= 18)) return _darkGreen;
        if (row == 7 && (col == 12 || col == 20)) return _darkGreen;
        if (row == 8 && (col == 10 || col == 22)) return _darkGreen;
        if (row == 9 && (col == 9 || col == 23)) return _darkGreen;
        if (row == 10 && (col == 8 || col == 24)) return _darkGreen;
        if ((row >= 11 && row <= 16) && (col == 8 || col == 24)) return _darkGreen;
        if (row == 17 && (col == 9 || col == 23)) return _darkGreen;
        if (row == 18 && (col == 10 || col == 22)) return _darkGreen;
        if (row == 19 && (col == 12 || col == 20)) return _darkGreen;
        if (row == 20 && (col >= 13 && col <= 19)) return _darkGreen;
      }

      return _empty;
    });
  });

  // Template 4: Cat (Con mèo)
  static final List<List<int>> _catTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Head outline (circular)
      if (row >= 10 && row <= 20 && col >= 10 && col <= 22) {
        if (row == 10 && (col >= 13 && col <= 19)) return _black;
        if (row == 11 && (col == 11 || col == 21)) return _black;
        if (row == 12 && (col == 10 || col == 22)) return _black;
        if ((row >= 13 && row <= 18) && (col == 10 || col == 22)) return _black;
        if (row == 19 && (col == 11 || col == 21)) return _black;
        if (row == 20 && (col >= 13 && col <= 19)) return _black;
      }

      // Left ear
      if (row >= 6 && row <= 10 && col >= 11 && col <= 14) {
        if (row == 6 && col == 12) return _black;
        if (row == 7 && (col == 11 || col == 13)) return _black;
        if (row == 8 && (col == 11 || col == 14)) return _black;
        if (row == 9 && (col == 11 || col == 14)) return _black;
        if (row == 10 && (col >= 11 && col <= 14)) return _black;
      }

      // Right ear
      if (row >= 6 && row <= 10 && col >= 18 && col <= 21) {
        if (row == 6 && col == 20) return _black;
        if (row == 7 && (col == 19 || col == 21)) return _black;
        if (row == 8 && (col == 18 || col == 21)) return _black;
        if (row == 9 && (col == 18 || col == 21)) return _black;
        if (row == 10 && (col >= 18 && col <= 21)) return _black;
      }

      // Left eye
      if (row >= 13 && row <= 15 && col >= 13 && col <= 15) {
        if (row == 13 && col == 14) return _black;
        if (row == 14 && (col == 13 || col == 15)) return _black;
        if (row == 15 && col == 14) return _black;
      }

      // Right eye
      if (row >= 13 && row <= 15 && col >= 17 && col <= 19) {
        if (row == 13 && col == 18) return _black;
        if (row == 14 && (col == 17 || col == 19)) return _black;
        if (row == 15 && col == 18) return _black;
      }

      // Nose
      if (row == 16 && col == 16) return _black;

      // Mouth
      if (row == 17 && col == 16) return _black;
      if (row == 18 && (col == 14 || col == 18)) return _black;

      // Whiskers
      if (row == 15 && (col >= 6 && col <= 9)) return _black;
      if (row == 15 && (col >= 23 && col <= 26)) return _black;
      if (row == 17 && (col >= 6 && col <= 9)) return _black;
      if (row == 17 && (col >= 23 && col <= 26)) return _black;

      return _empty;
    });
  });

  // Template 5: Sun (Mặt trời)
  static final List<List<int>> _sunTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      final dr = row - 16;
      final dc = col - 16;
      final dist2 = dr * dr + dc * dc;

      // Center circle outline (radius ~4)
      if (dist2 >= 12 && dist2 <= 20) return _darkYellow;

      // Cardinal rays: N, S, W, E
      if (dc == 0 && row >= 5 && row <= 10) return _darkYellow;
      if (dc == 0 && row >= 22 && row <= 27) return _darkYellow;
      if (dr == 0 && col >= 5 && col <= 10) return _darkYellow;
      if (dr == 0 && col >= 22 && col <= 27) return _darkYellow;

      // Diagonal rays: NW, NE, SW, SE
      if (dr == dc && dr <= -6 && dr >= -10) return _darkYellow;
      if (dr == -dc && dr <= -6 && dr >= -10) return _darkYellow;
      if (dr == dc && dr >= 6 && dr <= 10) return _darkYellow;
      if (dr == -dc && dr >= 6 && dr <= 10) return _darkYellow;

      return _empty;
    });
  });

  // Template 6: Butterfly (Bướm)
  static final List<List<int>> _butterflyTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Body (vertical oval in center)
      if (col == 16 && row >= 13 && row <= 22) return _darkBrown;
      if (col == 15 && (row == 14 || row == 21)) return _darkBrown;
      if (col == 17 && (row == 14 || row == 21)) return _darkBrown;

      // Antennae
      if (row == 12 && (col == 15 || col == 17)) return _darkBrown;
      if (row == 11 && (col == 14 || col == 18)) return _darkBrown;
      if (row == 10 && (col == 13 || col == 19)) return _darkBrown;
      if (row == 9 && (col == 12 || col == 20)) return _darkBrown;

      // Left upper wing (larger)
      if (row >= 9 && row <= 17 && col >= 6 && col <= 14) {
        if (row == 9 && (col >= 11 && col <= 13)) return _darkYellow;
        if (row == 10 && (col == 9 || col == 14)) return _darkYellow;
        if (row == 11 && (col == 7 || col == 14)) return _darkYellow;
        if (row == 12 && (col == 6 || col == 14)) return _darkYellow;
        if (row >= 13 && row <= 14 && (col == 6 || col == 14)) return _darkYellow;
        if (row == 15 && (col == 7 || col == 14)) return _darkYellow;
        if (row == 16 && (col == 8 || col == 14)) return _darkYellow;
        if (row == 17 && (col >= 10 && col <= 14)) return _darkYellow;
      }

      // Right upper wing (larger)
      if (row >= 9 && row <= 17 && col >= 18 && col <= 26) {
        if (row == 9 && (col >= 19 && col <= 21)) return _darkYellow;
        if (row == 10 && (col == 18 || col == 23)) return _darkYellow;
        if (row == 11 && (col == 18 || col == 25)) return _darkYellow;
        if (row == 12 && (col == 18 || col == 26)) return _darkYellow;
        if (row >= 13 && row <= 14 && (col == 18 || col == 26)) return _darkYellow;
        if (row == 15 && (col == 18 || col == 25)) return _darkYellow;
        if (row == 16 && (col == 18 || col == 24)) return _darkYellow;
        if (row == 17 && (col >= 18 && col <= 22)) return _darkYellow;
      }

      // Left lower wing (smaller)
      if (row >= 18 && row <= 23 && col >= 8 && col <= 14) {
        if (row == 18 && (col >= 10 && col <= 13)) return _darkYellow;
        if (row == 19 && (col == 9 || col == 14)) return _darkYellow;
        if (row == 20 && (col == 8 || col == 14)) return _darkYellow;
        if (row == 21 && (col == 8 || col == 14)) return _darkYellow;
        if (row == 22 && (col == 9 || col == 13)) return _darkYellow;
        if (row == 23 && (col >= 10 && col <= 12)) return _darkYellow;
      }

      // Right lower wing (smaller)
      if (row >= 18 && row <= 23 && col >= 18 && col <= 24) {
        if (row == 18 && (col >= 19 && col <= 22)) return _darkYellow;
        if (row == 19 && (col == 18 || col == 23)) return _darkYellow;
        if (row == 20 && (col == 18 || col == 24)) return _darkYellow;
        if (row == 21 && (col == 18 || col == 24)) return _darkYellow;
        if (row == 22 && (col == 19 || col == 23)) return _darkYellow;
        if (row == 23 && (col >= 20 && col <= 22)) return _darkYellow;
      }

      return _empty;
    });
  });

  // Template 7: Fish (Con cá)
  static final List<List<int>> _fishTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Body oval outline (center roughly at row 16, col 14)
      if (row >= 11 && row <= 21 && col >= 7 && col <= 22) {
        if (row == 11 && (col >= 12 && col <= 16)) return _darkRed;
        if (row == 12 && (col == 10 || col == 18)) return _darkRed;
        if (row == 13 && (col == 8 || col == 20)) return _darkRed;
        if (row == 14 && (col == 7 || col == 21)) return _darkRed;
        if (row == 15 && (col == 7 || col == 22)) return _darkRed;
        if (row == 16 && (col == 7 || col == 22)) return _darkRed;
        if (row == 17 && (col == 7 || col == 22)) return _darkRed;
        if (row == 18 && (col == 8 || col == 21)) return _darkRed;
        if (row == 19 && (col == 9 || col == 20)) return _darkRed;
        if (row == 20 && (col == 11 || col == 18)) return _darkRed;
        if (row == 21 && (col >= 13 && col <= 16)) return _darkRed;
      }

      // Tail fin (V-shape to the right)
      if (col == 23 && row >= 13 && row <= 19) return _darkRed;
      if (col == 24 && (row == 12 || row == 20)) return _darkRed;
      if (col == 25 && (row == 11 || row == 21)) return _darkRed;
      if (col == 26 && (row == 10 || row == 22)) return _darkRed;

      // Eye
      if (row == 14 && col == 11) return _darkYellow;
      if (row == 15 && (col == 10 || col == 12)) return _darkYellow;
      if (row == 16 && col == 11) return _darkYellow;

      // Dorsal fin (on top of body)
      if (col >= 13 && col <= 17 && row >= 7 && row <= 10) {
        if (row == 7 && col == 15) return _darkRed;
        if (row == 8 && (col == 14 || col == 16)) return _darkRed;
        if (row == 9 && (col == 13 || col == 17)) return _darkRed;
        if (row == 10 && (col == 13 || col == 17)) return _darkRed;
      }

      return _empty;
    });
  });

  // Template 8: House (Ngôi nhà)
  static final List<List<int>> _houseTemplate = List.generate(32, (row) {
    return List.generate(32, (col) {
      // Roof (triangle): apex at (row 8, col 16), base at row 17
      // Left slope: row - 8 == col - 16 → col = row - 8 + 16 = row + 8... wait
      // Left slope from apex (8,16) going down-left: col decreases as row increases
      // At row r: left col = 16 - (r - 8) = 24 - r; right col = 16 + (r - 8) = r + 8
      if (row >= 8 && row <= 17) {
        final leftCol = 24 - row;
        final rightCol = row + 8;
        if (col == leftCol || col == rightCol) return _darkRed;
        if (row == 17 && col >= leftCol && col <= rightCol) return _darkRed;
      }

      // Walls (rectangle): rows 17–27, left col 7, right col 25
      if (row >= 17 && row <= 27) {
        if (col == 7 || col == 25) return _darkBrown;
        if (row == 27 && col >= 7 && col <= 25) return _darkBrown;
      }

      // Door (centered): rows 21–27, cols 13–19
      if (row >= 21 && row <= 26 && col >= 13 && col <= 19) {
        if (col == 13 || col == 19) return _darkBrown;
        if (row == 21 && col >= 13 && col <= 19) return _darkBrown;
      }
      // Door arch top (small curve)
      if (row == 20 && (col == 14 || col == 18)) return _darkBrown;
      if (row == 19 && (col >= 15 && col <= 17)) return _darkBrown;

      // Left window: rows 19–23, cols 9–12
      if (row >= 19 && row <= 23 && col >= 9 && col <= 12) {
        if (col == 9 || col == 12) return _darkBrown;
        if (row == 19 || row == 23) return _darkBrown;
      }

      // Right window: rows 19–23, cols 20–23
      if (row >= 19 && row <= 23 && col >= 20 && col <= 23) {
        if (col == 20 || col == 23) return _darkBrown;
        if (row == 19 || row == 23) return _darkBrown;
      }

      return _empty;
    });
  });
}
