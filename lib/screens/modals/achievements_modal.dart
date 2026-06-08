import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_shapes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/models/display_item_group.dart';
import '../../core/providers/achievement_provider.dart';
import '../../core/utils/auth_service.dart';
import '../../core/utils/display_item_service.dart';
import '../../core/providers/score_provider.dart';
import '../../core/utils/achievement_service.dart';
import '../../core/widgets/app_modal.dart';
import '../../models/achievement_progress.dart';

class AchievementsModal {
  AchievementsModal._();

  static Future<void> show(
    BuildContext context, {
    void Function(String featureId)? onNavigate,
  }) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    if (size.width >= 720 && size.width > size.height && size.height >= 600) {
      return _showLandscape(context, onNavigate: onNavigate);
    }
    return AppModal.show(
      context: context,
      title: l10n.achievementsTitle,
      maxHeight: size.height * 0.92,
      content: _AchievementsContent(onNavigate: onNavigate),
    );
  }

  static Future<void> _showLandscape(
    BuildContext context, {
    void Function(String featureId)? onNavigate,
  }) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width.clamp(0.0, 640.0);
    final dialogHeight = size.height * 0.92;
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: AppModal(
            isDialog: true,
            title: l10n.achievementsTitle,
            content: _AchievementsContent(onNavigate: onNavigate, isDialog: true),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AchievementsContent extends StatefulWidget {
  final void Function(String featureId)? onNavigate;
  final bool isDialog;

  const _AchievementsContent({this.onNavigate, this.isDialog = false});

  @override
  State<_AchievementsContent> createState() => _AchievementsContentState();
}

class _AchievementsContentState extends State<_AchievementsContent> {
  bool _isDebugMode = false;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkDebugMode();
  }

  Future<void> _checkDebugMode() async {
    final isDebug = await _authService.isDebugMode;
    if (mounted) setState(() => _isDebugMode = isDebug);
  }

  static const _categoryOrder = [
    AchievementCategory.engagement,
    AchievementCategory.schedule,
    AchievementCategory.diary,
    AchievementCategory.breathing,
    AchievementCategory.sleep,
    AchievementCategory.garden,
    AchievementCategory.aquarium,
    AchievementCategory.painting,
    AchievementCategory.music,
    AchievementCategory.score,
  ];

  static const Map<AchievementCategory, DisplayItemGroup?> _catToGroup = {
    AchievementCategory.schedule:  DisplayItemGroup.schedule,
    AchievementCategory.diary:     DisplayItemGroup.diary,
    AchievementCategory.breathing: DisplayItemGroup.breathing,
    AchievementCategory.sleep:     DisplayItemGroup.sleep,
    AchievementCategory.garden:    DisplayItemGroup.garden,
    AchievementCategory.aquarium:  DisplayItemGroup.aquarium,
    AchievementCategory.painting:  DisplayItemGroup.painting,
    AchievementCategory.music:     DisplayItemGroup.music,
    AchievementCategory.engagement: DisplayItemGroup.engagement,
    AchievementCategory.score:      DisplayItemGroup.score,
  };

  static const _categoryFeatureId = {
    AchievementCategory.schedule: 'schedule',
    AchievementCategory.diary: 'diary',
    AchievementCategory.breathing: 'breathing',
    AchievementCategory.sleep: 'sleep',
    AchievementCategory.garden: 'garden',
    AchievementCategory.aquarium: 'aquarium',
    AchievementCategory.painting: 'painting',
    AchievementCategory.music: 'music',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = context.watch<AchievementProvider>().progress;
    final totalPoints = context.watch<ScoreProvider>().profile.totalPoints;

    final total = AchievementService.all.length;
    final unlocked = progress.unlockedIds.length;

    final categorySections = <Widget>[];
    if (widget.isDialog) {
      for (int i = 0; i < _categoryOrder.length; i += 2) {
        final cat1 = _categoryOrder[i];
        final cat2 = i + 1 < _categoryOrder.length ? _categoryOrder[i + 1] : null;
        categorySections.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCategorySection(context, l10n, cat1, progress, totalPoints)),
            const SizedBox(width: 16),
            Expanded(
              child: cat2 != null
                  ? _buildCategorySection(context, l10n, cat2, progress, totalPoints)
                  : const SizedBox(),
            ),
          ],
        ));
        categorySections.add(const SizedBox(height: 20));
      }
    } else {
      for (final cat in _categoryOrder) {
        categorySections.add(_buildCategorySection(context, l10n, cat, progress, totalPoints));
        categorySections.add(const SizedBox(height: 20));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProgressHeader(context, l10n, unlocked, total),
        const SizedBox(height: 20),
        ...categorySections,
      ],
    );
  }

  Widget _buildProgressHeader(
    BuildContext context,
    AppLocalizations l10n,
    int unlocked,
    int total,
  ) {
    final theme = context.theme;
    final fraction = total > 0 ? unlocked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.primary),
        borderRadius: context.shapes.medium.borderRadius as BorderRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.background,
              shape: BoxShape.circle,
              border: Border.all(color: theme.primary, width: 1.5),
            ),
            child: Icon(Icons.emoji_events_rounded, color: theme.primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unlocked / $total ${l10n.achievements}',
                  style: AppTypography.labelLarge(context,
                      color: theme.text, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 8,
                    backgroundColor: theme.border,
                    valueColor: AlwaysStoppedAnimation(theme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    AppLocalizations l10n,
    AchievementCategory cat,
    AchievementProgress progress,
    int totalPoints,
  ) {
    final group = _catToGroup[cat];
    if (group != null) {
      return _buildShelfSection(context, l10n, cat, group, progress, totalPoints);
    }
    return _buildCardSection(context, l10n, cat, progress, totalPoints);
  }

  // ── SHELF SECTION (for groups with display items) ─────────────────────────

  Widget _buildShelfSection(
    BuildContext context,
    AppLocalizations l10n,
    AchievementCategory cat,
    DisplayItemGroup group,
    AchievementProgress progress,
    int totalPoints,
  ) {
    final theme = context.theme;
    final tier = DisplayItemService.getTier(group, progress);
    final tracking = _trackingInfo(group, progress, totalPoints: totalPoints);
    final featureId = _categoryFeatureId[cat];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Text(
              l10n.achievementCategoryName(cat.name),
              style: AppTypography.labelMedium(context,
                  color: context.onSurfaceVariant, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Text(
              _trackingLabel(l10n, tracking),
              style: AppTypography.labelSmall(context, color: theme.text),
            ),
            const Spacer(),
            if (widget.onNavigate != null && featureId != null)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onNavigate!(featureId);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.goToFeature,
                        style: AppTypography.labelSmall(context,
                            color: context.primaryColor)),
                    const SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 11, color: context.primaryColor),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Shelf row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: theme.background,
            borderRadius: context.shapes.medium.borderRadius as BorderRadius,
            border: Border.all(color: _isDebugMode ? Colors.deepPurple : theme.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (i) {
              final slotTier = i + 1;
              final achId = group.achievementIds[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: i == 0 || i == 3 ? 4 : 3),
                  child: _ShelfSlot(
                    group: group,
                    slotTier: slotTier,
                    isUnlocked: tier >= slotTier,
                    achievementId: achId,
                    l10n: l10n,
                    isDebugMode: _isDebugMode,
                    onDebugTap: _isDebugMode
                        ? () => context.read<AchievementProvider>().debugToggleAchievement(achId)
                        : null,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // ── CARD SECTION (engagement / score — no display items) ─────────────────

  Widget _buildCardSection(
    BuildContext context,
    AppLocalizations l10n,
    AchievementCategory cat,
    AchievementProgress progress,
    int totalPoints,
  ) {
    final categoryAchievements =
        AchievementService.all.where((a) => a.category == cat).toList();
    final tracking = _cardTrackingText(l10n, cat, categoryAchievements, progress, totalPoints);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                l10n.achievementCategoryName(cat.name),
                style: AppTypography.labelMedium(context,
                    color: context.onSurfaceVariant, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (tracking != null) ...[
                Text(tracking,
                    style: AppTypography.labelSmall(context, color: context.theme.text)),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        ...categoryAchievements.map((ach) => _AchievementCard(
              achievement: ach,
              isUnlocked: progress.isUnlocked(ach.id),
              unlockedAtMs: progress.unlockedAt[ach.id],
              isDebugMode: _isDebugMode,
              onDebugTap: _isDebugMode
                  ? () => context.read<AchievementProvider>().debugToggleAchievement(ach.id)
                  : null,
            )),
      ],
    );
  }

  // ── Tracking helpers ─────────────────────────────────────────────────────

  static ({int current, int maxTarget, String unit}) _trackingInfo(
    DisplayItemGroup group,
    AchievementProgress progress, {
    int totalPoints = 0,
  }) {
    int c(String key) => progress.counter(key);
    return switch (group) {
      DisplayItemGroup.schedule   => (current: c(AchievementService.kScheduleTaskCount), maxTarget: 150,   unit: 'tasks'),
      DisplayItemGroup.diary      => (current: c(AchievementService.kDiaryCount),         maxTarget: 30,   unit: 'entries'),
      DisplayItemGroup.breathing  => (current: c(AchievementService.kBreathingTotal),     maxTarget: 30,   unit: 'sessions'),
      DisplayItemGroup.sleep      => (current: c(AchievementService.kSleepLogCount),      maxTarget: 30,   unit: 'logs'),
      DisplayItemGroup.garden     => (current: c(AchievementService.kPlantCount),         maxTarget: 160,  unit: 'plants'),
      DisplayItemGroup.aquarium   => (current: c(AchievementService.kFishFedCount),       maxTarget: 300,  unit: 'feedings'),
      DisplayItemGroup.painting   => (current: c(AchievementService.kPixelsPainted),      maxTarget: 5120, unit: 'pixels'),
      DisplayItemGroup.music      => (current: c(AchievementService.kNotesChanged),       maxTarget: 600,  unit: 'notes'),
      DisplayItemGroup.engagement => (current: c(AchievementService.kDaysUsed),           maxTarget: 30,   unit: 'days'),
      DisplayItemGroup.score      => (current: totalPoints,                                maxTarget: 20000, unit: 'points'),
    };
  }

  static String _trackingLabel(
    AppLocalizations l10n,
    ({int current, int maxTarget, String unit}) info,
  ) {
    final unit = l10n.achievementUnit(info.unit);
    if (info.current >= info.maxTarget) {
      return '${info.current} $unit';
    }
    return '${info.current} / ${info.maxTarget} $unit';
  }

  /// Progress text for card-only categories (engagement, score). Returns null if none apply.
  static String? _cardTrackingText(
    AppLocalizations l10n,
    AchievementCategory cat,
    List<Achievement> achievements,
    AchievementProgress progress,
    int totalPoints,
  ) {
    final locked = achievements.where((a) => !progress.isUnlocked(a.id));
    if (locked.isEmpty) return null;
    final info = _progressInfo(locked.first.id, progress, totalPoints);
    if (info == null) return null;
    return '${info.$1}/${info.$2} ${l10n.achievementUnit(info.$3)}';
  }

  static int _countBits(int n) {
    int c = 0; int v = n;
    while (v > 0) { c += v & 1; v >>= 1; }
    return c;
  }

  static (int, int, String)? _progressInfo(String id, AchievementProgress progress, int totalPoints) {
    int c(String key) => progress.counter(key);
    return switch (id) {
      'days_7'              => (c(AchievementService.kDaysUsed), 7, 'days'),
      'days_30'             => (c(AchievementService.kDaysUsed), 30, 'days'),
      'app_explorer'        => (_countBits(c(AchievementService.kFeaturesUsed)), 3, 'features'),
      'score_1000'          => (totalPoints, 1000, 'points'),
      'score_5000'          => (totalPoints, 5000, 'points'),
      'score_20000'         => (totalPoints, 20000, 'points'),
      _                     => null,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shelf slot widget

class _ShelfSlot extends StatelessWidget {
  final DisplayItemGroup group;
  final int slotTier;
  final bool isUnlocked;
  final String achievementId;
  final AppLocalizations l10n;
  final bool isDebugMode;
  final VoidCallback? onDebugTap;

  const _ShelfSlot({
    required this.group,
    required this.slotTier,
    required this.isUnlocked,
    required this.achievementId,
    required this.l10n,
    this.isDebugMode = false,
    this.onDebugTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final assetPath = AppAssets.displayItemAsset(group, slotTier);

    final image = ColorFiltered(
      colorFilter: isUnlocked
          ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
          : const ColorFilter.matrix([
              0, 0, 0, 0, 0.12,
              0, 0, 0, 0, 0.12,
              0, 0, 0, 0, 0.12,
              0, 0, 0, 1, 0,
            ]),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (ctx, err, st) => _buildImagePlaceholder(theme),
      ),
    );

    return GestureDetector(
      onLongPress: onDebugTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: isDebugMode
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurple.withValues(alpha: 0.5),
                        width: 1.5,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: image,
                  )
                : image,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.achievementTitle(achievementId),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall(context,
                color: isUnlocked ? theme.text : theme.border),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder(dynamic theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.border, width: 1.5),
      ),
      child: Center(
        child: Icon(_groupIcon(), size: 20, color: theme.border),
      ),
    );
  }

  IconData _groupIcon() => switch (group) {
    DisplayItemGroup.schedule  => Icons.task_alt,
    DisplayItemGroup.diary     => Icons.book_outlined,
    DisplayItemGroup.breathing => Icons.air,
    DisplayItemGroup.sleep     => Icons.bedtime_outlined,
    DisplayItemGroup.garden    => Icons.eco_outlined,
    DisplayItemGroup.aquarium  => Icons.water_drop_outlined,
    DisplayItemGroup.painting   => Icons.brush_outlined,
    DisplayItemGroup.music      => Icons.music_note_outlined,
    DisplayItemGroup.engagement => Icons.people_outline,
    DisplayItemGroup.score      => Icons.star_outline,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Achievement card (used for engagement / score categories)

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final int? unlockedAtMs;
  final bool isDebugMode;
  final VoidCallback? onDebugTap;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
    this.unlockedAtMs,
    this.isDebugMode = false,
    this.onDebugTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.theme;

    final iconColor = isUnlocked ? theme.primary : theme.border;
    final titleColor = isUnlocked ? theme.text : theme.border;
    final descColor = isUnlocked ? context.onSurfaceVariant : theme.border;
    final borderColor = isDebugMode
        ? Colors.deepPurple.withValues(alpha: 0.5)
        : isUnlocked ? theme.primary : theme.border;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onLongPress: onDebugTap,
        child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: context.shapes.medium.borderRadius as BorderRadius,
          border: Border.all(color: borderColor, width: isUnlocked || isDebugMode ? 1.5 : 1.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.background,
                    border: Border.all(color: borderColor, width: 1.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(achievement.icon, size: 22, color: iconColor),
                ),
                if (!isUnlocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: theme.background,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.border, width: 1.5),
                      ),
                      child: Icon(Icons.lock_outline, size: 10, color: iconColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.achievementTitle(achievement.id),
                      style: AppTypography.labelMedium(context,
                          color: titleColor, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(l10n.achievementDescription(achievement.id),
                      style: AppTypography.bodySmall(context, color: descColor)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isUnlocked)
              _buildUnlockedBadge(context, theme)
            else
              _buildPointsBadge(context, theme, l10n),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildUnlockedBadge(BuildContext context, dynamic theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.background,
            shape: BoxShape.circle,
            border: Border.all(color: theme.primary, width: 1.5),
          ),
          child: Icon(Icons.check_rounded, size: 16, color: theme.primary),
        ),
        if (achievement.pointsReward > 0) ...[
          const SizedBox(height: 2),
          Text('+${achievement.pointsReward}',
              style: AppTypography.bodySmall(context, color: theme.primary)),
        ],
      ],
    );
  }

  Widget _buildPointsBadge(BuildContext context, dynamic theme, AppLocalizations l10n) {
    if (achievement.pointsReward <= 0) return const SizedBox(width: 28);
    return Text('+${achievement.pointsReward}',
        style: AppTypography.bodySmall(context, color: theme.border));
  }
}
