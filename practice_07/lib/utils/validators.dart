class Validators {
  static String? name(String? v) {
    final val = (v ?? '').trim();
    if (val.length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  static String? email(String? v) {
    final val = v ?? '';
    if (!val.contains('@') || !val.substring(val.indexOf('@')).contains('.')) {
      return 'Email looks wrong';
    }
    return null;
  }

  static String? password(String? v) {
    final val = v ?? '';
    if (val.length < 8) {
      return 'Password is too short';
    }
    return null;
  }

  static String? confirmPassword(String? v, String password) {
    if ((v ?? '') != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? group(String? g) {
    return g == null ? 'Choose a group' : null;
  }

  static String? birthDate(DateTime? birth) {
    return birth == null ? 'Select date of birth' : null;
  }
}