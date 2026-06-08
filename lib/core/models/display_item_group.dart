import 'package:flutter/material.dart';
import '../../models/scene_models.dart';

enum DisplayItemGroup {
  schedule,
  diary,
  breathing,
  sleep,
  garden,
  aquarium,
  painting,
  music,
  engagement,
  score,
}

extension DisplayItemGroupX on DisplayItemGroup {
  /// Null means this group has no scene — modal-only.
  SceneType? get sceneType => switch (this) {
    DisplayItemGroup.schedule   => SceneType.livingRoom,
    DisplayItemGroup.diary      => SceneType.livingRoom,
    DisplayItemGroup.breathing  => SceneType.livingRoom,
    DisplayItemGroup.sleep      => SceneType.livingRoom,
    DisplayItemGroup.garden     => SceneType.garden,
    DisplayItemGroup.aquarium   => SceneType.aquarium,
    DisplayItemGroup.painting   => SceneType.paintingRoom,
    DisplayItemGroup.music      => SceneType.musicRoom,
    DisplayItemGroup.engagement => null,
    DisplayItemGroup.score      => null,
  };

  /// Achievement IDs ordered by tier (index 0 = tier 1, index 3 = tier 4).
  List<String> get achievementIds => switch (this) {
    DisplayItemGroup.schedule   => const ['first_schedule_task', 'schedule_task_15', 'schedule_task_75', 'schedule_task_150'],
    DisplayItemGroup.diary      => const ['first_diary', 'diary_5', 'diary_15', 'diary_30'],
    DisplayItemGroup.breathing  => const ['first_breath', 'breathing_5', 'breathing_15', 'breathing_30'],
    DisplayItemGroup.sleep      => const ['first_sleep_log', 'sleep_log_5', 'sleep_log_15', 'sleep_log_30'],
    DisplayItemGroup.garden     => const ['first_plant', 'plant_30', 'plant_80', 'plant_160'],
    DisplayItemGroup.aquarium   => const ['first_fish_fed', 'fish_fed_15', 'fish_fed_150', 'fish_fed_300'],
    DisplayItemGroup.painting   => const ['first_painting', 'painting_pixels_512', 'painting_pixels_2560', 'painting_pixels_5120'],
    DisplayItemGroup.music      => const ['first_music', 'music_notes_60', 'music_notes_300', 'music_notes_600'],
    DisplayItemGroup.engagement => const ['first_steps', 'app_explorer', 'days_7', 'days_30'],
    DisplayItemGroup.score      => const ['score_100', 'score_1000', 'score_5000', 'score_20000'],
  };

  /// Living-room groups shape-change each tier; all others accumulate distinct items.
  bool get isShapeChange => sceneType == SceneType.livingRoom;
}

/// Data for a single display item rendered as a scene overlay.
class DisplayItemData {
  final String id;
  final String asset;

  /// Normalized center position (0.0–1.0) relative to sceneSize.
  /// In a Positioned widget: left = position.dx * size - itemSize/2
  final Offset position;

  final DisplayItemGroup group;

  const DisplayItemData({
    required this.id,
    required this.asset,
    required this.position,
    required this.group,
  });
}
