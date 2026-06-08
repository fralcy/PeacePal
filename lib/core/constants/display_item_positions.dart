import 'package:flutter/material.dart';
import '../../models/scene_models.dart';
import '../models/display_item_group.dart';

class DisplayItemPositions {

  // ── LIVING ROOM (shape-change groups) ────────────────────────────────────
  // Each group has one fixed position per scene set.
  // Keep the 4 groups spatially distinct and away from:
  //   • mascot: center-bottom (~x 0.30–0.70, y 0.50–1.00)
  //   • speech bubble: center (~y 0.35–0.55)

  static final Map<DisplayItemGroup, Map<SceneSet, Offset>> _living = {
    DisplayItemGroup.schedule: {       // cork memo board
      SceneSet.defaultSet:   const Offset(0.12, 0.30),
      SceneSet.forest:       const Offset(0.80, 0.30),
      SceneSet.beach:        const Offset(0.86, 0.30),
      SceneSet.peachBlossom: const Offset(0.86, 0.20),
      SceneSet.winter:       const Offset(0.86, 0.30),
      SceneSet.desert:       const Offset(0.74, 0.30),
      SceneSet.cosmic:       const Offset(0.48, 0.34),
      SceneSet.castle:       const Offset(0.89, 0.22),
    },
    DisplayItemGroup.diary: {          // journal book
      SceneSet.defaultSet:   const Offset(0.76, 0.72),
      SceneSet.forest:       const Offset(0.18, 0.72),
      SceneSet.beach:        const Offset(0.24, 0.58),
      SceneSet.peachBlossom: const Offset(0.18, 0.72),
      SceneSet.winter:       const Offset(0.24, 0.58),
      SceneSet.desert:       const Offset(0.15, 0.62),
      SceneSet.cosmic:       const Offset(0.94, 0.90),
      SceneSet.castle:       const Offset(0.80, 0.60),
    },
    DisplayItemGroup.breathing: {      // pinwheel toy
      SceneSet.defaultSet:   const Offset(0.84, 0.56),
      SceneSet.forest:       const Offset(0.12, 0.42),
      SceneSet.beach:        const Offset(0.50, 0.48),
      SceneSet.peachBlossom: const Offset(0.62, 0.52),
      SceneSet.winter:       const Offset(0.50, 0.48),
      SceneSet.desert:       const Offset(0.26, 0.30),
      SceneSet.cosmic:       const Offset(0.74, 0.60),
      SceneSet.castle:       const Offset(0.67, 0.56),
    },
    DisplayItemGroup.sleep: {          // moon pillow
      SceneSet.defaultSet:   const Offset(0.44, 0.30),
      SceneSet.forest:       const Offset(0.85, 0.62),
      SceneSet.beach:        const Offset(0.76, 0.58),
      SceneSet.peachBlossom: const Offset(0.85, 0.82),
      SceneSet.winter:       const Offset(0.76, 0.58),
      SceneSet.desert:       const Offset(0.85, 0.62),
      SceneSet.cosmic:       const Offset(0.26, 0.42),
      SceneSet.castle:       const Offset(0.245, 0.19),
    },
  };

  // ── GAME-ROOM GROUPS (accumulate up to 4 instances) ──────────────────────
  // Slot 0 = tier-1 item, slot 1 = tier-2 item, etc.
  // Positions should not overlap. Tier-N items include all slots 0..N-1.

  static final Map<DisplayItemGroup, Map<SceneSet, List<Offset>>> _gameRoom = {
    DisplayItemGroup.garden: {         // succulent, mushroom, water can, statue
      SceneSet.defaultSet:   const [Offset(0.12, 0.70), Offset(0.20, 0.80), Offset(0.88, 0.70), Offset(0.80, 0.80)],
      SceneSet.forest:       const [Offset(0.12, 0.90), Offset(0.20, 0.80), Offset(0.88, 0.90), Offset(0.80, 0.80)],
      SceneSet.beach:        const [Offset(0.12, 0.90), Offset(0.20, 0.80), Offset(0.88, 0.90), Offset(0.80, 0.80)],
      SceneSet.peachBlossom: const [Offset(0.12, 0.90), Offset(0.20, 0.80), Offset(0.88, 0.90), Offset(0.80, 0.80)],
      SceneSet.winter:       const [Offset(0.12, 0.90), Offset(0.20, 0.80), Offset(0.88, 0.90), Offset(0.80, 0.80)],
      SceneSet.desert:       const [Offset(0.20, 0.94), Offset(0.26, 0.86), Offset(0.74, 0.86), Offset(0.80, 0.94)],
      SceneSet.cosmic:       const [Offset(0.20, 0.94), Offset(0.26, 0.86), Offset(0.74, 0.86), Offset(0.80, 0.94)],
      SceneSet.castle:       const [Offset(0.20, 0.94), Offset(0.26, 0.86), Offset(0.74, 0.86), Offset(0.80, 0.94)],
    },
    DisplayItemGroup.aquarium: {       // fish toys, treasure chest, anchor, coral
      SceneSet.defaultSet:   const [Offset(0.54, 0.46), Offset(0.825, 0.24), Offset(0.36, 0.46), Offset(0.18, 0.46)],
      SceneSet.forest:       const [Offset(0.36, 0.46), Offset(0.775, 0.18), Offset(0.54, 0.46), Offset(0.80, 0.82)],
      SceneSet.beach:        const [Offset(0.88, 0.84), Offset(0.18, 0.50), Offset(0.54, 0.50), Offset(0.36, 0.50)],
      SceneSet.peachBlossom: const [Offset(0.18, 0.50), Offset(0.54, 0.50), Offset(0.36, 0.50), Offset(0.88, 0.84)],
      SceneSet.winter:       const [Offset(0.18, 0.50), Offset(0.54, 0.50), Offset(0.36, 0.50), Offset(0.88, 0.84)],
      SceneSet.desert:       const [Offset(0.50, 0.20), Offset(0.20, 0.88), Offset(0.27, 0.56), Offset(0.80, 0.54)],
      SceneSet.cosmic:       const [Offset(0.20, 0.90), Offset(0.38, 0.30), Offset(0.60, 0.30), Offset(0.80, 0.65)],
      SceneSet.castle:       const [Offset(0.08, 0.82), Offset(0.66, 0.13), Offset(0.35, 0.45), Offset(0.77, 0.68)],
    },
    DisplayItemGroup.painting: {       // paint tubes, palette, brushes, mini canva
      SceneSet.defaultSet:   const [Offset(0.245, 0.80), Offset(0.12, 0.28), Offset(0.84, 0.56), Offset(0.88, 0.84)],
      SceneSet.forest:       const [Offset(0.245, 0.80), Offset(0.88, 0.28), Offset(0.62, 0.52), Offset(0.88, 0.84)],
      SceneSet.beach:        const [Offset(0.24, 0.84), Offset(0.88, 0.28), Offset(0.18, 0.78), Offset(0.88, 0.84)],
      SceneSet.peachBlossom: const [Offset(0.245, 0.80), Offset(0.88, 0.28), Offset(0.62, 0.52), Offset(0.88, 0.84)],
      SceneSet.winter:       const [Offset(0.24, 0.84), Offset(0.88, 0.28), Offset(0.18, 0.78), Offset(0.88, 0.84)],
      SceneSet.desert:       const [Offset(0.82, 0.38), Offset(0.06, 0.58), Offset(0.16, 0.38), Offset(0.88, 0.84)],
      SceneSet.cosmic:       const [Offset(0.10, 0.84), Offset(0.22, 0.52), Offset(0.78, 0.68), Offset(0.88, 0.84)],
      SceneSet.castle:       const [Offset(0.12, 0.86), Offset(0.15, 0.43), Offset(0.26, 0.86), Offset(0.86, 0.86)],
    },
    DisplayItemGroup.music: {          // note plushie, juke box, headphone, speaker
      SceneSet.defaultSet:   const [Offset(0.73, 0.26), Offset(0.245, 0.80), Offset(0.84, 0.56), Offset(0.28, 0.26)],
      SceneSet.forest:       const [Offset(0.15, 0.30), Offset(0.62, 0.52), Offset(0.38, 0.52), Offset(0.85, 0.30)],
      SceneSet.beach:        const [Offset(0.85, 0.30), Offset(0.70, 0.48), Offset(0.50, 0.46), Offset(0.24, 0.60)],
      SceneSet.peachBlossom: const [Offset(0.15, 0.30), Offset(0.62, 0.52), Offset(0.38, 0.52), Offset(0.85, 0.30)],
      SceneSet.winter:       const [Offset(0.15, 0.30), Offset(0.62, 0.52), Offset(0.38, 0.52), Offset(0.85, 0.30)],
      SceneSet.desert:       const [Offset(0.92, 0.25), Offset(0.68, 0.58), Offset(0.32, 0.58), Offset(0.08, 0.20)],
      SceneSet.cosmic:       const [Offset(0.72, 0.15), Offset(0.88, 0.84), Offset(0.38, 0.50), Offset(0.16, 0.35)],
      SceneSet.castle:       const [Offset(0.50, 0.20), Offset(0.88, 0.84), Offset(0.12, 0.84), Offset(0.20, 0.44)],
    },
  };

  // ── Public getters ────────────────────────────────────────────────────────

  static Offset getLivingRoomPosition(DisplayItemGroup group, SceneSet sceneSet) {
    return _living[group]?[sceneSet]
        ?? _living[group]?[SceneSet.defaultSet]
        ?? Offset.zero;
  }

  static List<Offset> getGameRoomSlots(DisplayItemGroup group, SceneSet sceneSet) {
    return _gameRoom[group]?[sceneSet]
        ?? _gameRoom[group]?[SceneSet.defaultSet]
        ?? const [];
  }
}
