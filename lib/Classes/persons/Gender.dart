import '../../main.dart';

class Gender {
  final String genderLetter; // "M"/"F"/"D"
  String address;

  Gender(this.genderLetter, this.address);

  factory Gender.male({String address = "Mr."}) {
    return Gender("M", address);
  }

  factory Gender.female({String address = "Ms."}) {
    return Gender("F", address);
  }

  factory Gender.diverse(String address) {
    return Gender("D", address);
  }

  factory Gender.fromLetter(String letter, {String address = ""}) {
    if (address.isEmpty) {
      address = letter == "M"
          ? "Mr."
          : letter == "F"
              ? "Ms."
              : "";
    }
    switch (letter) {
      case "M":
        return Gender.male(address: address);
      case "F":
        return Gender.female(address: address);
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
