class SubCountryState {
  final String name;
  final String code;
  SubCountryState(this.name, this.code);

  factory SubCountryState.fromJson(Map<String, dynamic> json) {
    return SubCountryState(
        json['toponymName'], json['adminCodes1']["ISO3166_2"]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubCountryState && other.name == name && other.code == code;
  }
}
