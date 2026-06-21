class Country {
  final String name;
  final String code;
  final Uri flag;

  Country(this.name, this.code, this.flag);

  factory Country.fromJson(Map<String, dynamic> json) {
    final code = json['cca2'] as String;
    return Country(json['name']['common'], code,
        Uri.parse('https://flagcdn.com/w320/${code.toLowerCase()}.png'));
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
