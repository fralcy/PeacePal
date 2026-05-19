import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_theme.dart';
import '../../core/constants/app_typography.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/utils/data_manager.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_modal.dart';
import '../../core/widgets/line_graph.dart';

class DashboardModal extends StatelessWidget {
  const DashboardModal({super.key});

  static bool _isLandscape(Size size) =>
      size.width >= 720 && size.width > size.height && size.height >= 600;

  static Future<void> show(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    if (_isLandscape(size)) {
      return _showLandscape(context, l10n, size);
    }
    return AppModal.show(
      context: context,
      title: l10n.dashboard,
      maxHeight: size.height * 0.92,
      content: const DashboardModal(),
    );
  }

  static Future<void> _showLandscape(
      BuildContext context, AppLocalizations l10n, Size size) {
    final dialogWidth = (size.width * 0.92).clamp(0.0, 1200.0);
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
            title: l10n.dashboard,
            scrollable: false,
            content: const DashboardModal(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.theme;
    final size = MediaQuery.of(context).size;
    final isLandscape = _isLandscape(size);

    final moodCard = AppCard(
      title: l10n.moodTrend,
      content: _MoodTrendSection(l10n: l10n, theme: theme),
    );
    final sleepCard = AppCard(
      title: l10n.sleepTrend,
      content: _SleepTrendSection(l10n: l10n, theme: theme),
    );
    final breathingCard = AppCard(
      title: l10n.breathingThisWeek,
      content: _BreathingSection(l10n: l10n, theme: theme),
    );

    if (isLandscape) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: moodCard),
            const SizedBox(width: 12),
            Expanded(child: sleepCard),
            const SizedBox(width: 12),
            Expanded(child: breathingCard),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          moodCard,
          const SizedBox(height: 12),
          sleepCard,
          const SizedBox(height: 12),
          breathingCard,
        ],
      ),
    );
  }
}

class _MoodTrendSection extends StatelessWidget {
  final AppLocalizations l10n;
  final AppTheme theme;

  const _MoodTrendSection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    final diaries = DataManager().emotionDiaries;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final values = List<double?>.generate(14, (i) {
      final targetDate = today.subtract(Duration(days: 13 - i));
      final entry = diaries.where((d) {
        final d0 = DateTime(d.date.year, d.date.month, d.date.day);
        return d0 == targetDate;
      }).firstOrNull;
      if (entry == null) return null;
      return (entry.q1 + (6 - entry.q2) + entry.q3) / 3.0;
    });

    final hasData = values.any((v) => v != null);

    if (!hasData) {
      return _noDataWidget(context);
    }

    final average = _average(values);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineGraph(
          values: values,
          labels: _dayLabels(),
          minY: 1,
          maxY: 5,
          yUnit: '',
          height: 140,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.averageScore}: ${average.toStringAsFixed(1)} / 5',
          style: AppTypography.bodySmall(context, color: theme.text.withOpacity(0.65)),
        ),
      ],
    );
  }
}

class _SleepTrendSection extends StatelessWidget {
  final AppLocalizations l10n;
  final AppTheme theme;

  const _SleepTrendSection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    final logs = DataManager().sleepLogs;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final qualityValues = List<double?>.generate(14, (i) {
      final targetDate = today.subtract(Duration(days: 13 - i));
      final log = logs.where((l) {
        final d0 = DateTime(l.date.year, l.date.month, l.date.day);
        return d0 == targetDate;
      }).firstOrNull;
      return log?.quality?.toDouble();
    });

    final durationValues = List<double?>.generate(14, (i) {
      final targetDate = today.subtract(Duration(days: 13 - i));
      final log = logs.where((l) {
        final d0 = DateTime(l.date.year, l.date.month, l.date.day);
        return d0 == targetDate;
      }).firstOrNull;
      return log?.durationHours;
    });

    final hasData = qualityValues.any((v) => v != null);

    if (!hasData) {
      return _noDataWidget(context);
    }

    final avgHours = _average(durationValues);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineGraph(
          values: qualityValues,
          labels: _dayLabels(),
          minY: 1,
          maxY: 5,
          yUnit: '',
          height: 140,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.averageScore}: ${avgHours.toStringAsFixed(1)}h',
          style: AppTypography.bodySmall(context, color: theme.text.withOpacity(0.65)),
        ),
      ],
    );
  }
}

class _BreathingSection extends StatelessWidget {
  final AppLocalizations l10n;
  final AppTheme theme;

  const _BreathingSection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    final allSessions = DataManager().breathingSessions;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final thisWeek = allSessions.where((s) => s.date.isAfter(weekAgo)).toList();

    if (thisWeek.isEmpty) {
      return _noDataWidget(context);
    }

    final totalSessions = thisWeek.length;
    final totalMinutes =
        thisWeek.fold(0, (sum, s) => sum + s.durationSeconds) ~/ 60;

    final byType = <String, int>{};
    for (final s in thisWeek) {
      byType[s.exerciseType] = (byType[s.exerciseType] ?? 0) + 1;
    }
    final typeBreakdown = byType.entries
        .map((e) => '${e.key}: ${e.value}')
        .join('  ·  ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatChip(
                value: '$totalSessions',
                label: l10n.sessions,
                theme: theme,
              ),
              const SizedBox(width: 12),
              _StatChip(
                value: '$totalMinutes',
                label: 'min',
                theme: theme,
              ),
            ],
          ),
          if (typeBreakdown.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              typeBreakdown,
              style: AppTypography.bodySmall(context,
                  color: theme.text.withOpacity(0.65)),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final AppTheme theme;

  const _StatChip({
    required this.value,
    required this.label,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: value,
              style: AppTypography.h4(context, color: theme.primary),
            ),
            TextSpan(
              text: ' $label',
              style: AppTypography.bodySmall(context,
                  color: theme.text.withOpacity(0.65)),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _noDataWidget(BuildContext context) {
  final theme = context.theme;
  final l10n = AppLocalizations.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Center(
      child: Text(
        l10n.noDataYet,
        style: AppTypography.bodyMedium(context,
            color: theme.text.withOpacity(0.5)),
      ),
    ),
  );
}

List<String> _dayLabels() {
  return List.generate(14, (i) => '${13 - i}');
}

double _average(List<double?> values) {
  final nonNull = values.whereType<double>().toList();
  if (nonNull.isEmpty) return 0;
  return nonNull.reduce((a, b) => a + b) / nonNull.length;
}
