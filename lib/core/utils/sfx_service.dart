import 'package:flutter_soloud/flutter_soloud.dart';
import 'data_manager.dart';

/// Service quản lý sound effects cho toàn app.
/// Singleton — pre-load toàn bộ file SFX vào memory khi init.
class SfxService {
  static final SfxService _instance = SfxService._internal();
  factory SfxService() => _instance;
  SfxService._internal();

  final Map<String, AudioSource> _handles = {};
  bool _isEnabled = true;
  double _volume = 0.7;

  static const Map<String, String> _sfxAssets = {
    'button_click': 'assets/audio/sfx/button_click.mp3',
    'task_complete': 'assets/audio/sfx/task_complete.mp3',
    'reward': 'assets/audio/sfx/reward.mp3',
    'error': 'assets/audio/sfx/error.mp3',
    'page_transition': 'assets/audio/sfx/page_transition.mp3',
    'celebration': 'assets/audio/sfx/celebration.mp3',
    'rock_hit': 'assets/audio/sfx/rock_hit.mp3',
    'rock_land': 'assets/audio/sfx/rock_land.mp3',
  };

  Future<void> initialize() async {
    final settings = DataManager().userSettings;
    _isEnabled = settings.sfxEnabled;
    _volume = settings.sfxVolume / 100.0;

    for (final entry in _sfxAssets.entries) {
      _handles[entry.key] =
          await SoLoud.instance.loadAsset(entry.value);
    }
  }

  void _play(String key) {
    if (!_isEnabled || _volume == 0) return;
    final source = _handles[key];
    if (source != null) SoLoud.instance.play(source, volume: _volume);
  }

  void buttonClick() => _play('button_click');
  void taskComplete() => _play('task_complete');
  void reward() => _play('reward');
  void error() => _play('error');
  void pageTransition() => _play('page_transition');
  void celebration() => _play('celebration');
  void rockHit() => _play('rock_hit');
  void rockLand() => _play('rock_land');
  // Falls back to button_click until assets/audio/sfx/item_tap.mp3 is provided.
  void itemTap() => _handles.containsKey('item_tap') ? _play('item_tap') : _play('button_click');

  void changeVolume(int volume) => _volume = volume / 100.0;

  void setEnabled(bool enabled) => _isEnabled = enabled;

  void applySettings() {
    final settings = DataManager().userSettings;
    setEnabled(settings.sfxEnabled);
    changeVolume(settings.sfxVolume);
  }

  Future<void> dispose() async {
    for (final source in _handles.values) {
      await SoLoud.instance.disposeSource(source);
    }
    _handles.clear();
  }
}
