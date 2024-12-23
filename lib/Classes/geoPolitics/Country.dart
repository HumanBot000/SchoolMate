class Country {
  final String name;
  final String code;
  final Uri flag;

  Country(this.name, this.code, this.flag);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
        json['name']['common'], json['cca2'], Uri.parse(json['flags']['svg']));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Country &&
        other.name == name &&
        other.code == code &&
        other.flag == flag;
  }
}
