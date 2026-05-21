import 'dart:math';

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_theme.dart';
import '../../core/constants/app_typography.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/utils/auth_service.dart';
import '../../core/utils/data_manager.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_modal.dart';
import '../../core/widgets/line_graph.dart';
import '../../models/breathing_session.dart';
import '../../models/emotion_diary.dart';
import '../../models/sleep_log.dart';

class DashboardModal extends StatefulWidget {
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
  State<DashboardModal> createState() => _DashboardModalState();
}

class _DashboardModalState extends State<DashboardModal> {
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

  Future<void> _debugFillDashboardData() async {
    final dm = DataManager();
    final rng = Random();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    const exerciseTypes = ['4-7-8', 'box', 'deep_belly', 'calm'];

    // Diary: days 1-13, skip today so user can manually test mascot/suggestion
    final diaries = List.generate(13, (i) => EmotionDiary(
      date: today.subtract(Duration(days: i + 1)),
      q1: rng.nextInt(5) + 1,
      q2: rng.nextInt(5) + 1,
      q3: rng.nextInt(5) + 1,
      notes: '',
    ))..sort((a, b) => b.date.compareTo(a.date));
    await dm.saveEmotionDiaries(diaries);

    // Breathing: randomly pick 5-8 days out of 13
    final days = List.generate(13, (i) => i + 1)..shuffle(rng);
    final breathingDays = days.take(5 + rng.nextInt(4)).toList();
    await dm.saveBreathingSessions([
      for (final d in breathingDays)
        BreathingSession(
          date: today.subtract(Duration(days: d)).add(Duration(hours: 18 + rng.nextInt(4))),
          exerciseType: exerciseTypes[rng.nextInt(exerciseTypes.length)],
          durationSeconds: 120 + rng.nextInt(181),
          cyclesCompleted: rng.nextInt(5) + 1,
        ),
    ]);

    // Sleep: 8-10 days, only quality needed for chart
    final sleepCount = 8 + rng.nextInt(3);
    await dm.saveSleepLogs([
      for (int d = 1; d <= sleepCount; d++)
        SleepLog(
          date: today.subtract(Duration(days: d)),
          quality: rng.nextInt(5) + 1,
        ),
    ]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.theme;
    final size = MediaQuery.of(context).size;
    final isLandscape = DashboardModal._isLandscape(size);

    final moodCard = AppCard(
      title: l10n.moodTrend,
      content: _MoodTrendSection(l10n: l10n, theme: theme),
    );
    final sleepQualityCard = AppCard(
      title: l10n.sleepQuality,
      content: _SleepQualitySection(l10n: l10n, theme: theme),
    );
    final sleepDurationCard = AppCard(
      title: l10n.sleepDuration,
      content: _SleepDurationSection(l10n: l10n, theme: theme),
    );
    final sleepColumn = Column(
      children: [
        sleepQualityCard,
        const SizedBox(height: 12),
        sleepDurationCard,
      ],
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final insightCutoff = today.subtract(const Duration(days: 13));
    final recentDiaryCount = DataManager().emotionDiaries.where((d) {
      final date = DateTime(d.date.year, d.date.month, d.date.day);
      return !date.isBefore(insightCutoff);
    }).length;
    final insightCard = recentDiaryCount >= 3
        ? AppCard(
            title: l10n.insightTitle,
            content: _InsightSection(l10n: l10n, theme: theme),
          )
        : null;

    final debugSection = _isDebugMode
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Divider(color: theme.border, height: 1, thickness: 1.5),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _debugFillDashboardData,
                icon: const Icon(Icons.bug_report, size: 18),
                label: const Text('[DEBUG] Fill test data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          )
        : null;

    if (isLandscape) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: moodCard),
                const SizedBox(width: 12),
                Expanded(child: sleepQualityCard),
                const SizedBox(width: 12),
                Expanded(child: sleepDurationCard),
              ],
            ),
            if (insightCard != null) ...[
              const SizedBox(height: 12),
              insightCard,
            ],
            if (debugSection != null) debugSection,
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
          sleepColumn,
          if (insightCard != null) ...[
            const SizedBox(height: 12),
            insightCard,
          ],
          if (debugSection != null) debugSection,
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
      return (entry.q1 + entry.q2 + entry.q3) / 3.0;
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

class _SleepQualitySection extends StatelessWidget {
  final AppLocalizations l10n;
  final AppTheme theme;

  const _SleepQualitySection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    final logs = DataManager().sleepLogs;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final values = List<double?>.generate(14, (i) {
      final targetDate = today.subtract(Duration(days: 13 - i));
      final log = logs.where((l) {
        final d0 = DateTime(l.date.year, l.date.month, l.date.day);
        return d0 == targetDate;
      }).firstOrNull;
      return log?.quality?.toDouble();
    });

    if (!values.any((v) => v != null)) return _noDataWidget(context);

    final avg = _average(values);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineGraph(
          values: values,
          labels: _dayLabels(),
          minY: 1,
          maxY: 5,
          yUnit: '',
          height: 120,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.averageScore}: ${avg.toStringAsFixed(1)} / 5',
          style: AppTypography.bodySmall(context,
              color: theme.text.withOpacity(0.65)),
        ),
      ],
    );
  }
}

class _SleepDurationSection extends StatelessWidget {
  final AppLocalizations l10n;
  final AppTheme theme;

  const _SleepDurationSection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    final logs = DataManager().sleepLogs;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final values = List<double?>.generate(14, (i) {
      final targetDate = today.subtract(Duration(days: 13 - i));
      final log = logs.where((l) {
        final d0 = DateTime(l.date.year, l.date.month, l.date.day);
        return d0 == targetDate;
      }).firstOrNull;
      return log?.durationHours;
    });

    if (!values.any((v) => v != null)) return _noDataWidget(context);

    final avg = _average(values);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LineGraph(
          values: values,
          labels: _dayLabels(),
          minY: 0,
          maxY: 12,
          yUnit: 'h',
          height: 120,
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.averageScore}: ${avg.toStringAsFixed(1)}h',
          style: AppTypography.bodySmall(context,
              color: theme.text.withOpacity(0.65)),
        ),
      ],
    );
  }
}



class _InsightSection extends StatelessWidget {
  final AppLocalizations l10n;
  final AppTheme theme;

  const _InsightSection({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    final diaries = DataManager().emotionDiaries;
    final sleepLogs = DataManager().sleepLogs;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cutoff = today.subtract(const Duration(days: 13));

    // Collect days that have both diary AND sleep data
    final paired = <({EmotionDiary diary, SleepLog sleep})>[];
    for (final d in diaries) {
      final date = DateTime(d.date.year, d.date.month, d.date.day);
      if (date.isBefore(cutoff)) continue;
      final sleep = sleepLogs.where((s) {
        final sd = DateTime(s.date.year, s.date.month, s.date.day);
        return sd == date;
      }).firstOrNull;
      if (sleep == null ||
          sleep.durationHours == null ||
          sleep.quality == null) { continue; }
      paired.add((diary: d, sleep: sleep));
    }

    if (paired.length < 5) return const SizedBox.shrink();

    final goodSleep = paired
        .where((p) =>
            p.sleep.durationHours! >= 7.0 && p.sleep.quality! >= 4)
        .toList();
    final badSleep = paired
        .where((p) =>
            p.sleep.durationHours! < 6.5 || p.sleep.quality! <= 2)
        .toList();

    double avgQ2(List<({EmotionDiary diary, SleepLog sleep})> items) =>
        items.isEmpty
            ? 3.0
            : items.map((p) => p.diary.q2.toDouble()).reduce((a, b) => a + b) /
                items.length;

    double avgScore(List<({EmotionDiary diary, SleepLog sleep})> items) =>
        items.isEmpty
            ? 3.0
            : items
                    .map((p) =>
                        (p.diary.q1 + p.diary.q2 + p.diary.q3) / 3.0)
                    .reduce((a, b) => a + b) /
                items.length;

    final String message;
    if (badSleep.length >= 2 && avgQ2(badSleep) <= 2.5) {
      message = l10n.insightStressFromPoorSleep;
    } else if (goodSleep.length >= 2 && avgScore(goodSleep) >= 4.0) {
      message = l10n.insightGoodMoodFromGoodSleep;
    } else if (goodSleep.length >= 2 && avgQ2(goodSleep) <= 2.5) {
      message = l10n.insightStressNotFromSleep;
    } else {
      message = l10n.insightKeepItUp;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: AppTypography.bodyMedium(context, color: theme.text),
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
