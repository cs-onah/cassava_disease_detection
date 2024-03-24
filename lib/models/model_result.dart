import 'dart:math';

class ModelResult {
  double mosaic;
  double blight;
  double brownStreak;
  double greenMite;

  double get solution => [mosaic, blight, brownStreak, greenMite].reduce(max);

  ModelResult({
    this.mosaic = 0,
    this.blight = 0,
    this.brownStreak = 0,
    this.greenMite = 0,
  });

  ModelResult copyWith({
    double? mosaic,
    double? blight,
    double? brownStreak,
    double? greenMite,
  }) =>
      ModelResult(
        mosaic: mosaic ?? this.mosaic,
        blight: blight ?? this.blight,
        brownStreak: brownStreak ?? this.brownStreak,
        greenMite: greenMite ?? this.greenMite,
      );

  factory ModelResult.fromJson(Map<String, dynamic> json) => ModelResult(
        mosaic: json["Mosaic_N"]?.toDouble() ?? 0,
        blight: json["blight_N"]?.toDouble() ?? 0,
        brownStreak: json["brownstreak_N"]?.toDouble() ?? 0,
        greenMite: json["greenmite_N"]?.toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Mosaic": mosaic,
        "Blight": blight,
        "Brown Streak": brownStreak,
        "Green Mite": greenMite,
      };
}
