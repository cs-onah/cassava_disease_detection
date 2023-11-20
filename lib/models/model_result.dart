class ModelResult {
  double mosaic;
  double blight;
  double brownStreak;
  double greenMite;

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
    mosaic: json["Mosaic"]?.toDouble() ?? 0,
    blight: json["Blight"]?.toDouble() ?? 0,
    brownStreak: json["Brown Streak"]?.toDouble() ?? 0,
    greenMite: json["Green Mite"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "Mosaic": mosaic,
    "Blight": blight,
    "Brown Streak": brownStreak,
    "Green Mite": greenMite,
  };
}
