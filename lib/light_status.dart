class LightStatus {
  final double brightness; // in range 0..1.0

  LightStatus(this.brightness);

  LightStatus.fromJson(Map<String, dynamic> json)
      : brightness = json['brightness'];

  Map<String, dynamic> toJson() => {
        'brightness': brightness,
      };
}
