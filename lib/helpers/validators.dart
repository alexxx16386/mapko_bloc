class Validators {
  String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "Введите email";
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return "Введите корректный email";
    }
    return null;
  }

  String? usernameValidator(String? value) {
    if (value!.isEmpty) {
      return null;
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+").hasMatch(value)) {
      return "A-z, 0-9";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Введите пароль";
    }
    if (value.length < 6) {
      return "Минимальная длина пароля - 6";
    }
    return null;
  }

  String? password2Validator(String? value1, value2) {
    if (value2!.isEmpty) {
      return "Повторно введите пароль";
    }
    if (value1! != value2!) {
      return "Пароли не совпадают";
    }
    return null;
  }
}
