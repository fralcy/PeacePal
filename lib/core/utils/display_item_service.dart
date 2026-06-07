import '../../models/achievement_progress.dart';
import '../../models/scene_models.dart';
import '../constants/app_assets.dart';
import '../constants/display_item_positions.dart';
import '../models/display_item_group.dart';

class DisplayItemService {
  /// Returns the highest tier (0–4) unlocked for [group].
  static int getTier(DisplayItemGroup group, AchievementProgress progress) {
    int tier = 0;
    for (final id in group.achievementIds) {
      if (progress.isUnlocked(id)) tier++;
    }
    return tier;
  }

  /// Returns all display items to show for [sceneType] / [sceneSet].
  static List<DisplayItemData> getItemsForScene(
    SceneType sceneType,
    SceneSet sceneSet,
    AchievementProgress progress,
  ) {
    final items = <DisplayItemData>[];
    for (final group in DisplayItemGroup.values) {
      if (group.sceneType != sceneType) continue;
      final tier = getTier(group, progress);
      if (tier == 0) continue;

      if (group.isShapeChange) {
        // Living-room: show only the highest-tier item (replaces previous)
        items.add(DisplayItemData(
          id: group.name,
          asset: AppAssets.displayItemAsset(group, tier),
          position: DisplayItemPositions.getLivingRoomPosition(group, sceneSet),
          group: group,
        ));
      } else {
        // Game-room: show all unlocked items simultaneously, each distinct
        final slots = DisplayItemPositions.getGameRoomSlots(group, sceneSet);
        for (int i = 0; i < tier && i < slots.length; i++) {
          items.add(DisplayItemData(
            id: '${group.name}_$i',
            asset: AppAssets.displayItemAsset(group, i + 1),
            position: slots[i],
            group: group,
          ));
        }
      }
    }
    return items;
  }
}
