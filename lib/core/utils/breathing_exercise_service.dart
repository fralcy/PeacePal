/// Service for breathing exercise logic
/// Provides exercise configurations, phase detection, and animation calculations
class BreathingExerciseService {
  static final BreathingExerciseService _instance =
      BreathingExerciseService._internal();
  factory BreathingExerciseService() => _instance;
  BreathingExerciseService._internal();

  /// Exercise configurations: {name: {inhale, hold, exhale, pause}}
  /// All durations in seconds
  static const Map<String, Map<String, int>> exercises = {
    '4-7-8': {'inhale': 4, 'hold': 7, 'exhale': 8, 'pause': 0},
    'box': {'inhale': 4, 'hold': 4, 'exhale': 4, 'pause': 4},
    'deep_belly': {'inhale': 5, 'hold': 2, 'exhale': 6, 'pause': 0},
    'calm': {'inhale': 4, 'hold': 2, 'exhale': 6, 'pause': 2},
  };

  /// Hai bài có thể tùy chỉnh độ dài từng pha: Thở bụng sâu (Jerath et al.,
  /// 2015) và Thở bình tĩnh (Anxiety Canada). 4-7-8 và Thở hộp giữ cố định
  /// vì là kỹ thuật chuẩn, không nên thay đổi tỉ lệ pha.
  static const Set<String> customizableExercises = {'deep_belly', 'calm'};

  /// Số pha cố định và khác nhau cho hai bài tùy chỉnh, để không bị trùng
  /// cấu trúc: deep_belly = 3 pha (hít/giữ/thở), calm = 4 pha (hít/giữ/thở/nghỉ).
  /// pause của deep_belly luôn = 0 (ẩn pha) và pause của calm luôn >= 1 (luôn hiện pha).
  static const Map<String, List<String>> activePhaseOrder = {
    'deep_belly': ['inhale', 'hold', 'exhale'],
    'calm': ['inhale', 'hold', 'exhale', 'pause'],
  };

  /// Giới hạn mỗi pha (giây), để tránh giá trị vô lý.
  static const int minPhaseSeconds = 1;
  static const int maxPhaseSeconds = 10;

  /// Khoảng nhịp thở/phút mục tiêu theo cơ sở lý thuyết của từng bài, dùng để
  /// giữ tổng chu kỳ gần với khuyến nghị khi người dùng tùy chỉnh:
  /// - deep_belly: thở chậm có kiểm soát để kích hoạt phó giao cảm (mục 2.5),
  ///   thường được khuyến nghị quanh 4-7 lần/phút.
  /// - calm: kỹ thuật "calm breathing" của Anxiety Canada, làm chậm nhịp thở
  ///   ở mức vừa phải hơn, khoảng 4-8 lần/phút.
  static const Map<String, List<int>> targetBpmRange = {
    'deep_belly': [4, 7],
    'calm': [4, 8],
  };

  /// Giới hạn riêng cho pha "pause" để đảm bảo deep_belly luôn ẩn pha này
  /// (giữ 3 pha) và calm luôn hiện pha này (giữ 4 pha).
  static const Map<String, List<int>> pauseBoundsByExercise = {
    'deep_belly': [0, 0],
    'calm': [1, 6],
  };

  /// Chỉnh lại (clamp) một bộ pha tùy chỉnh do người dùng nhập, để:
  /// 1. Mỗi pha nằm trong [minPhaseSeconds, maxPhaseSeconds] (riêng pause theo
  ///    [pauseBoundsByExercise]).
  /// 2. Tổng chu kỳ quy đổi ra nhịp thở/phút nằm trong [targetBpmRange].
  Map<String, int> clampCustomPhases(
      String exerciseType, Map<String, int> phases) {
    final order = activePhaseOrder[exerciseType];
    if (order == null) return Map<String, int>.from(phases);

    final pauseBounds = pauseBoundsByExercise[exerciseType] ?? [0, 0];
    final result = <String, int>{};
    for (final key in order) {
      final raw = phases[key] ?? 0;
      if (key == 'pause') {
        result[key] = raw.clamp(pauseBounds[0], pauseBounds[1]);
      } else {
        result[key] = raw.clamp(minPhaseSeconds, maxPhaseSeconds);
      }
    }

    final bpmRange = targetBpmRange[exerciseType] ?? [4, 10];
    final minTotal = (60 / bpmRange[1]).ceil(); // bpm cao nhất -> chu kỳ ngắn nhất
    final maxTotal = (60 / bpmRange[0]).floor(); // bpm thấp nhất -> chu kỳ dài nhất
    final total = order.fold<int>(0, (sum, k) => sum + result[k]!);

    if (total < minTotal || total > maxTotal) {
      final targetTotal = total < minTotal ? minTotal : maxTotal;
      final scale = targetTotal / total;
      for (final key in order) {
        final scaled = (result[key]! * scale).round();
        if (key == 'pause') {
          result[key] = scaled.clamp(pauseBounds[0], pauseBounds[1]);
        } else {
          result[key] = scaled.clamp(minPhaseSeconds, maxPhaseSeconds);
        }
      }
    }

    // Luôn giữ pha không thuộc activePhaseOrder (ví dụ pause của deep_belly) = 0
    for (final key in ['inhale', 'hold', 'exhale', 'pause']) {
      result.putIfAbsent(key, () => 0);
    }
    return result;
  }

  /// Tính nhịp thở/phút từ một bộ pha (dùng để hiển thị cho người dùng khi tùy chỉnh)
  double getBreathsPerMinute(Map<String, int> phases) {
    final total = phases.values.fold<int>(0, (sum, v) => sum + v);
    if (total <= 0) return 0;
    return 60 / total;
  }

  /// Get exercise configuration by type, ưu tiên cấu hình tùy chỉnh nếu có
  /// (chỉ áp dụng cho [customizableExercises])
  Map<String, int> getExerciseConfig(
      String exerciseType, [Map<String, int>? customPhases]) {
    if (customPhases != null &&
        customizableExercises.contains(exerciseType)) {
      return clampCustomPhases(exerciseType, customPhases);
    }
    return exercises[exerciseType] ?? exercises['4-7-8']!;
  }

  /// Calculate total cycle duration in seconds
  int getCycleDuration(String exerciseType, [Map<String, int>? customPhases]) {
    final config = getExerciseConfig(exerciseType, customPhases);
    return config.values.reduce((a, b) => a + b);
  }

  /// Get current phase and progress based on elapsed seconds in cycle
  /// Returns {'phase': 'inhale'|'hold'|'exhale'|'pause', 'progress': 0.0-1.0}
  Map<String, dynamic> getCurrentPhase(
      String exerciseType, int elapsedInCycle, [Map<String, int>? customPhases]) {
    final config = getExerciseConfig(exerciseType, customPhases);
    int acc = 0;

    final inhale = config['inhale']!;
    final hold = config['hold']!;
    final exhale = config['exhale']!;
    final pause = config['pause']!;

    // Inhale phase
    acc += inhale;
    if (elapsedInCycle < acc) {
      return {
        'phase': 'inhale',
        'progress': inhale > 0 ? elapsedInCycle / inhale : 1.0
      };
    }

    // Hold phase (skip if duration is 0)
    if (hold > 0) {
      acc += hold;
      if (elapsedInCycle < acc) {
        return {
          'phase': 'hold',
          'progress': (elapsedInCycle - (acc - hold)) / hold
        };
      }
    }

    // Exhale phase
    acc += exhale;
    if (elapsedInCycle < acc) {
      return {
        'phase': 'exhale',
        'progress': exhale > 0 ? (elapsedInCycle - (acc - exhale)) / exhale : 1.0
      };
    }

    // Pause phase (skip if duration is 0)
    return {
      'phase': 'pause',
      'progress': pause > 0 ? (elapsedInCycle - acc) / pause : 1.0
    };
  }

  /// Get mascot scale for breathing animation
  /// Returns scale factor: 1.0 (normal) to 1.3 (expanded)
  double getMascotScale(String phase, double progress) {
    switch (phase) {
      case 'inhale':
        return 1.0 + (0.3 * progress); // 1.0 → 1.3
      case 'exhale':
        return 1.3 - (0.3 * progress); // 1.3 → 1.0
      case 'hold':
        return 1.3; // Stay expanded
      case 'pause':
      default:
        return 1.0; // Stay normal
    }
  }
}
