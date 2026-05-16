import '../../models/music_progress.dart';

/// Các sample nhạc piano cho mini game sáng tác
/// User sẽ dùng các mẫu này làm cơ sở để chỉnh sửa
class MusicSamples {
  // Cấu hình âm nhạc
  static const int durationSeconds = 12;
  static const int bpm = 120;
  static const int totalBeats = (durationSeconds * bpm) ~/ 60; // 24 beats

  // Danh sách tất cả samples
  static final List<MusicTrack> samples = [
    MusicTrack(
      name: 'Twinkle Twinkle Little Star',
      createdAt: DateTime(2024, 1, 1),
      tracks: _twinkleTwinkleTracks,
    ),
    MusicTrack(
      name: 'Happy Birthday',
      createdAt: DateTime(2024, 1, 1),
      tracks: _happyBirthdayTracks,
    ),
    MusicTrack(
      name: 'Mary Had a Little Lamb',
      createdAt: DateTime(2024, 1, 1),
      tracks: _maryLambTracks,
    ),
    MusicTrack(
      name: 'Für Elise (Opening)',
      createdAt: DateTime(2024, 1, 1),
      tracks: _furEliseTracks,
    ),
    MusicTrack(
      name: 'Ode to Joy',
      createdAt: DateTime(2024, 1, 1),
      tracks: _odeToJoyTracks,
    ),
    MusicTrack(
      name: "Brahms' Lullaby",
      createdAt: DateTime(2024, 1, 1),
      tracks: _brahmsLullabyTracks,
    ),
    MusicTrack(
      name: 'London Bridge',
      createdAt: DateTime(2024, 1, 1),
      tracks: _londonBridgeTracks,
    ),
    MusicTrack(
      name: 'You Are My Sunshine',
      createdAt: DateTime(2024, 1, 1),
      tracks: _youAreMysunshineTracks,
    ),
  ];

  // Helper: tính milliseconds từ beat index
  static int _beatToMs(double beatIndex) {
    final secondsPerBeat = 60.0 / bpm;
    return (beatIndex * secondsPerBeat * 1000).round();
  }

  // Helper: tạo note với pitch (1-8 tương ứng C major scale: C D E F G A B C)
  static Note _note(int pitch, double beatIndex) {
    final pitches = ['C', 'D', 'E', 'F', 'G', 'A', 'B', 'C'];
    return Note(
      pitch: pitches[pitch - 1],
      startTimeMilliseconds: _beatToMs(beatIndex),
    );
  }

  // Sample 1: Twinkle Twinkle Little Star
  // Giai điệu: C C G G | A A G - | F F E E | D D C -
  // (Lặp lại nửa sau: G G F F | E E D - | G G F F | E E D -)
  static final Map<Instrument, List<Note>> _twinkleTwinkleTracks = {
    Instrument.key: [
      // Câu 1: Twin-kle twin-kle lit-tle star
      _note(1, 0.0),   // C - Twin
      _note(1, 1.0),   // C - kle
      _note(5, 2.0),   // G - twin
      _note(5, 3.0),   // G - kle
      _note(6, 4.0),   // A - lit
      _note(6, 5.0),   // A - tle
      _note(5, 6.0),   // G - star
      // beat 7: rest
      
      // Câu 2: How I won-der what you are
      _note(4, 8.0),   // F - How
      _note(4, 9.0),   // F - I
      _note(3, 10.0),  // E - won
      _note(3, 11.0),  // E - der
      _note(2, 12.0),  // D - what
      _note(2, 13.0),  // D - you
      _note(1, 14.0),  // C - are
      // beat 15: rest
      
      // Câu 3: Up a-bove the world so high
      _note(5, 16.0),  // G - Up
      _note(5, 17.0),  // G - a
      _note(4, 18.0),  // F - bove
      _note(4, 19.0),  // F - the
      _note(3, 20.0),  // E - world
      _note(3, 21.0),  // E - so
      _note(2, 22.0),  // D - high
      // beat 23: rest
    ],
  };

  // Sample 2: Happy Birthday
  // Giai điệu: G G A G | C B - - | G G A G | D C - -
  static final Map<Instrument, List<Note>> _happyBirthdayTracks = {
    Instrument.key: [
      // Câu 1: Hap-py birth-day to you
      _note(5, 0.0),   // G - Hap (pickup)
      _note(5, 0.5),   // G - py
      _note(6, 1.5),   // A - birth
      _note(5, 3.0),   // G - day
      _note(8, 4.5),   // C (high) - to
      _note(7, 6.0),   // B - you
      // beats 7-8: rest
      
      // Câu 2: Hap-py birth-day to you
      _note(5, 8.0),   // G - Hap (pickup)
      _note(5, 8.5),   // G - py
      _note(6, 9.5),   // A - birth
      _note(5, 11.0),  // G - day
      _note(2, 12.5),  // D - to (beat 2 lên 1 octave = note 2)
      _note(1, 14.0),  // C - you (beat 1 lên 1 octave)
      // beats 15-16: rest
      
      // Câu 3: Hap-py birth-day dear...
      _note(5, 16.0),  // G - Hap
      _note(5, 16.5),  // G - py
      _note(6, 17.5),  // A - birth
      _note(5, 19.0),  // G - day
      _note(4, 20.5),  // F - dear
      _note(3, 22.0),  // E - (name)
      // beat 23: rest
    ],
  };

  // Sample 3: Mary Had a Little Lamb
  // Giai điệu: E D C D | E E E - | D D D - | E G G -
  static final Map<Instrument, List<Note>> _maryLambTracks = {
    Instrument.key: [
      // Câu 1: Ma-ry had a lit-tle lamb
      _note(3, 0.0),   // E - Ma
      _note(2, 1.0),   // D - ry
      _note(1, 2.0),   // C - had
      _note(2, 3.0),   // D - a
      _note(3, 4.0),   // E - lit
      _note(3, 5.0),   // E - tle
      _note(3, 6.0),   // E - lamb
      // beat 7: rest
      
      // Câu 2: Lit-tle lamb, lit-tle lamb
      _note(2, 8.0),   // D - Lit
      _note(2, 9.0),   // D - tle
      _note(2, 10.0),  // D - lamb
      // beat 11: rest
      _note(3, 12.0),  // E - Lit
      _note(5, 13.0),  // G - tle
      _note(5, 14.0),  // G - lamb
      // beat 15: rest
      
      // Câu 3: Ma-ry had a lit-tle lamb
      _note(3, 16.0),  // E - Ma
      _note(2, 17.0),  // D - ry
      _note(1, 18.0),  // C - had
      _note(2, 19.0),  // D - a
      _note(3, 20.0),  // E - lit
      _note(3, 21.0),  // E - tle
      _note(3, 22.0),  // E - lamb
      // beat 23: rest
    ],
  };

  // Sample 4: Für Elise (Opening)
  // Giai điệu nổi tiếng: E D# E D# E B D C A
  // Vì chỉ có C major scale, sẽ điều chỉnh thành: E E E E E B D C A
  // (hoặc đơn giản hơn: E D E D E G F E D)
  static final Map<Instrument, List<Note>> _furEliseTracks = {
    Instrument.key: [
      // Phrase chính (lặp lại pattern đặc trưng)
      _note(3, 0.0),   // E
      _note(2, 0.5),   // D
      _note(3, 1.0),   // E
      _note(2, 1.5),   // D
      _note(3, 2.0),   // E
      _note(7, 2.5),   // B (note 7)
      _note(2, 3.0),   // D
      _note(1, 3.5),   // C
      _note(6, 4.0),   // A
      // beat 5: rest
      
      // Lặp lại với biến thể
      _note(3, 6.0),   // E
      _note(2, 6.5),   // D
      _note(3, 7.0),   // E
      _note(2, 7.5),   // D
      _note(3, 8.0),   // E
      _note(7, 8.5),   // B
      _note(2, 9.0),   // D
      _note(1, 9.5),   // C
      _note(6, 10.0),  // A
      // beats 11-12: rest
      
      // Câu tiếp theo
      _note(1, 12.0),  // C
      _note(3, 13.0),  // E
      _note(6, 14.0),  // A
      _note(7, 15.0),  // B
      
      // Kết thúc phrase
      _note(3, 16.0),  // E
      _note(5, 17.0),  // G
      _note(8, 18.0),  // C (high)
      _note(7, 19.0),  // B
      _note(5, 20.0),  // G
      _note(3, 21.0),  // E
      _note(2, 22.0),  // D
      _note(1, 23.0),  // C
    ],
  };

  // Sample 5: Ode to Joy (Beethoven Symphony No. 9)
  // Giai điệu: E E F G | G F E D | C C D E | E D D | (lặp)
  static final Map<Instrument, List<Note>> _odeToJoyTracks = {
    Instrument.key: [
      // Câu 1: E E F G | G F E D
      _note(3, 0.0),   // E
      _note(3, 1.0),   // E
      _note(4, 2.0),   // F
      _note(5, 3.0),   // G
      _note(5, 4.0),   // G
      _note(4, 5.0),   // F
      _note(3, 6.0),   // E
      _note(2, 7.0),   // D

      // Câu 2: C C D E | E D D
      _note(1, 8.0),   // C
      _note(1, 9.0),   // C
      _note(2, 10.0),  // D
      _note(3, 11.0),  // E
      _note(3, 12.0),  // E (hold)
      _note(2, 14.0),  // D
      _note(2, 15.0),  // D (hold)

      // Lặp lại câu 1
      _note(3, 16.0),  // E
      _note(3, 17.0),  // E
      _note(4, 18.0),  // F
      _note(5, 19.0),  // G
      _note(5, 20.0),  // G
      _note(4, 21.0),  // F
      _note(3, 22.0),  // E
      _note(2, 23.0),  // D
    ],
  };

  // Sample 6: Brahms' Lullaby
  // Giai điệu ru ngủ nổi tiếng, nhịp 3/4 điều chỉnh sang 24 beats
  static final Map<Instrument, List<Note>> _brahmsLullabyTracks = {
    Instrument.key: [
      // "Lul-la-by and good-night"
      _note(1, 0.0),   // C  - Lul
      _note(1, 2.0),   // C  - la
      _note(3, 3.0),   // E  - by
      _note(5, 4.0),   // G  - and
      _note(5, 6.0),   // G  - good
      // beat 7: rest

      // "with ro-ses be-dight"
      _note(3, 8.0),   // E  - with
      _note(3, 10.0),  // E  - ro
      _note(5, 11.0),  // G  - ses
      _note(8, 12.0),  // C' - be
      _note(8, 14.0),  // C' - dight
      // beat 15: rest

      // "Lay thee down now and rest"
      _note(5, 16.0),  // G  - Lay
      _note(3, 18.0),  // E  - thee
      _note(1, 20.0),  // C  - down
      _note(2, 22.0),  // D  - now
      // beat 23: rest
    ],
  };

  // Sample 7: London Bridge
  // Giai điệu: G A G F | E F G | D E F | E F G
  static final Map<Instrument, List<Note>> _londonBridgeTracks = {
    Instrument.key: [
      // "Lon-don Bridge is fall-ing down"
      _note(5, 0.0),   // G  - Lon
      _note(6, 1.0),   // A  - don
      _note(5, 2.0),   // G  - Bridge
      _note(4, 3.0),   // F  - is
      _note(3, 4.0),   // E  - fall
      _note(4, 5.0),   // F  - ing
      _note(5, 6.0),   // G  - down
      // beat 7: rest

      // "fall-ing down, fall-ing down"
      _note(2, 8.0),   // D  - fall
      _note(3, 9.0),   // E  - ing
      _note(4, 10.0),  // F  - down
      // beat 11: rest
      _note(3, 12.0),  // E  - fall
      _note(4, 13.0),  // F  - ing
      _note(5, 14.0),  // G  - down
      // beat 15: rest

      // "Lon-don Bridge is fall-ing down, my fair la-dy"
      _note(5, 16.0),  // G  - Lon
      _note(6, 17.0),  // A  - don
      _note(5, 18.0),  // G  - Bridge
      _note(4, 19.0),  // F  - is
      _note(3, 20.0),  // E  - fall
      _note(4, 21.0),  // F  - ing
      _note(5, 22.0),  // G  - down
      // beat 23: rest
    ],
  };

  // Sample 8: You Are My Sunshine
  // Giai điệu: C C C A | G(hold) | E G A G | E C
  static final Map<Instrument, List<Note>> _youAreMysunshineTracks = {
    Instrument.key: [
      // "You are my sun-shine"
      _note(1, 0.0),   // C  - You
      _note(1, 1.0),   // C  - are
      _note(1, 2.0),   // C  - my
      _note(6, 3.0),   // A  - sun
      _note(5, 4.0),   // G  - shine (hold)
      // beats 5-7: rest

      // "my on-ly sun-shine"
      _note(3, 8.0),   // E  - my
      _note(5, 9.0),   // G  - on
      _note(6, 10.0),  // A  - ly
      _note(5, 11.0),  // G  - sun
      _note(3, 12.0),  // E  - shine
      _note(1, 13.0),  // C  (hold)
      // beats 14-15: rest

      // "You make me hap-py when skies are grey"
      _note(1, 16.0),  // C  - You
      _note(1, 17.0),  // C  - make
      _note(3, 18.0),  // E  - me
      _note(5, 19.0),  // G  - hap
      _note(6, 20.0),  // A  - py
      _note(5, 21.0),  // G  - when
      _note(3, 22.0),  // E  - skies
      _note(1, 23.0),  // C  - are
    ],
  };
}
