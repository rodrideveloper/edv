String? validateEmail(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return 'Email vacio';
  } else if (!value
      .contains(RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"))) {
    return 'email invalido';
  }

  return null;
}

String? validatePassword(String value) {
  value = value.trim();

  if (value.isEmpty) {
    return 'Password vacio';
  } else if (value.length < 6) {
    return 'password menor a 6 caracteres';
  }

  return null;
}

/// Validate text is not empty nor null nor is only made of whitespaces
bool isValidText(String? text) => text != null && text.trim().isNotEmpty;
