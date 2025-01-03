import '../../main.dart';

class Gender {
  final String genderLetter; // "M"/"F"/"D"
  String address;

  Gender(this.genderLetter, this.address);

  factory Gender.male() {
    return Gender("M", "Mr.");
  }

  factory Gender.female() {
    return Gender("F", "Ms.");
  }

  factory Gender.diverse(String address) {
    return Gender("D", address);
  }

  factory Gender.fromLetter(String letter, {String address = ""}) {
    switch (letter) {
      case "M":
        return Gender.male();
      case "F":
        return Gender.female();
      case "D":
        return Gender.diverse(address);
      default:
        logger.w("Invalid gender letter: $letter");
        throw FormatException("Invalid gender letter: $letter");
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is Gender) {
      return genderLetter == other.genderLetter;
    }
    return false;
  }
}
