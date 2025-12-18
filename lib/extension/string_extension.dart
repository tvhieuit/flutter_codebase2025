extension StringExtension on String {
  bool get isEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  bool get isPhoneNumber {
    return RegExp(r'^[0-9]{10,15}$').hasMatch(this);
  }
}

