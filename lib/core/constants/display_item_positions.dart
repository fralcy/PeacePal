import 'package:flutter/material.dart';
import '../../models/scene_models.dart';
import '../models/display_item_group.dart';

/// Scene positions for display items — normalized CENTER fractions (0.0–1.0).
///
/// HOW TO USE:
///   1. Open a scene image at any size in your image editor.
///   2. Mark the desired center point of the display item.
///   3. Divide the pixel coordinates by the image width/height.
///   4. Update the corresponding Offset below.
///
/// In Flutter: left = cx * sceneSize − itemSize/2
///             top  = cy * sceneSize − itemSize/2
///
/// All values are PLACEHOLDER — update after image-editor testing.

class DisplayItemPositions {

  // ── LIVING ROOM (shape-change groups) ────────────────────────────────────
  // Each group has one fixed position per scene set.
  // Keep the 4 groups spatially distinct and away from:
  //   • mascot: center-bottom (~x 0.30–0.70, y 0.50–1.00)
  //   • speech bubble: center (~y 0.35–0.55)

  static final Map<DisplayItemGroup, Map<SceneSet, Offset>> _living = {
    DisplayItemGroup.schedule: {       // cork memo board — upper-right wall area
      SceneSet.defaultSet:   const Offset(0.80, 0.30),
      SceneSet.forest:       const Offset(0.80, 0.30),
      SceneSet.beach:        const Offset(0.80, 0.30),
      SceneSet.peachBlossom: const Offset(0.80, 0.30),
      SceneSet.winter:       const Offset(0.80, 0.30),
      SceneSet.desert:       const Offset(0.80, 0.30),
      SceneSet.cosmic:       const Offset(0.80, 0.30),
      SceneSet.castle:       const Offset(0.80, 0.30),
    },
    DisplayItemGroup.diary: {          // journal — lower-left surface
      SceneSet.defaultSet:   const Offset(0.18, 0.72),
      SceneSet.forest:       const Offset(0.18, 0.72),
      SceneSet.beach:        const Offset(0.18, 0.72),
      SceneSet.peachBlossom: const Offset(0.18, 0.72),
      SceneSet.winter:       const Offset(0.18, 0.72),
      SceneSet.desert:       const Offset(0.18, 0.72),
      SceneSet.cosmic:       const Offset(0.18, 0.72),
      SceneSet.castle:       const Offset(0.18, 0.72),
    },
    DisplayItemGroup.breathing: {      // pinwheel — left-middle (window / open area)
      SceneSet.defaultSet:   const Offset(0.12, 0.42),
      SceneSet.forest:       const Offset(0.12, 0.42),
      SceneSet.beach:        const Offset(0.12, 0.42),
      SceneSet.peachBlossom: const Offset(0.12, 0.42),
      SceneSet.winter:       const Offset(0.12, 0.42),
      SceneSet.desert:       const Offset(0.12, 0.42),
      SceneSet.cosmic:       const Offset(0.12, 0.42),
      SceneSet.castle:       const Offset(0.12, 0.42),
    },
    DisplayItemGroup.sleep: {          // moon pillow — right-middle (couch / seat area)
      SceneSet.defaultSet:   const Offset(0.85, 0.62),
      SceneSet.forest:       const Offset(0.85, 0.62),
      SceneSet.beach:        const Offset(0.85, 0.62),
      SceneSet.peachBlossom: const Offset(0.85, 0.62),
      SceneSet.winter:       const Offset(0.85, 0.62),
      SceneSet.desert:       const Offset(0.85, 0.62),
      SceneSet.cosmic:       const Offset(0.85, 0.62),
      SceneSet.castle:       const Offset(0.85, 0.62),
    },
  };

  // ── GAME-ROOM GROUPS (accumulate up to 4 instances) ──────────────────────
  // Slot 0 = tier-1 item, slot 1 = tier-2 item, etc.
  // Positions should not overlap. Tier-N items include all slots 0..N-1.

  static final Map<DisplayItemGroup, Map<SceneSet, List<Offset>>> _gameRoom = {
    DisplayItemGroup.garden: {         // succulent pots — along background fence/wall
      SceneSet.defaultSet:   const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.forest:       const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.beach:        const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.peachBlossom: const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.winter:       const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.desert:       const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.cosmic:       const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
      SceneSet.castle:       const [Offset(0.12, 0.28), Offset(0.28, 0.24), Offset(0.44, 0.26), Offset(0.62, 0.22)],
    },
    DisplayItemGroup.aquarium: {       // fish toys — bottom corners / tank floor
      SceneSet.defaultSet:   const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.forest:       const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.beach:        const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.peachBlossom: const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.winter:       const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.desert:       const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.cosmic:       const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
      SceneSet.castle:       const [Offset(0.08, 0.82), Offset(0.28, 0.88), Offset(0.55, 0.84), Offset(0.80, 0.82)],
    },
    DisplayItemGroup.painting: {       // paint tubes — shelf / worktable upper-right
      SceneSet.defaultSet:   const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.forest:       const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.beach:        const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.peachBlossom: const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.winter:       const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.desert:       const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.cosmic:       const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
      SceneSet.castle:       const [Offset(0.82, 0.35), Offset(0.88, 0.28), Offset(0.82, 0.22), Offset(0.88, 0.16)],
    },
    DisplayItemGroup.music: {          // note plushies — stand / shelf upper-left
      SceneSet.defaultSet:   const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.forest:       const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.beach:        const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.peachBlossom: const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.winter:       const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.desert:       const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.cosmic:       const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
      SceneSet.castle:       const [Offset(0.15, 0.30), Offset(0.25, 0.24), Offset(0.15, 0.18), Offset(0.25, 0.12)],
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
