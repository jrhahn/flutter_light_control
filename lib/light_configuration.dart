class LightConfiguration {
  final String ipAddress;
  final String name;

  LightConfiguration(this.ipAddress, this.name);

  LightConfiguration.fromJson(Map<String, dynamic> json)
    : ipAddress = json['ipAddress'],
      name = json['name'];

  Map<String, dynamic> toJson() => {
    'ipAddress': ipAddress,
    'name': name
  };

  @override
  String toString() {
    return "$name ($ipAddress):";

  }
}