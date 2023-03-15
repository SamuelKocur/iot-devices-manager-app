// Classes generated using: https://javiercbk.github.io/json_to_dart/

class LoginRequest {
  String? email;
  String? password;

  LoginRequest({
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

class RegisterRequest {
  String? email;
  String? password1;
  String? password2;
  String? firstName;
  String? lastName;

  RegisterRequest({
    this.email,
    this.password1,
    this.password2,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password1'] = password1;
    data['password2'] = password2;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}

class ChangePasswordRequest {
  String? oldPassword;
  String? newPassword;
  String? confirmedPassword;

  ChangePasswordRequest({
    this.oldPassword,
    this.newPassword,
    this.confirmedPassword,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['old_password'] = oldPassword;
    data['new_password'] = newPassword;
    data['confirmed_password'] = confirmedPassword;
    return data;
  }
}


class UpdateProfileRequest {
  String? firstName;
  String? lastName;

  UpdateProfileRequest({this.firstName, this.lastName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstName != null) {
      data['first_name'] = firstName;
    }
    if (lastName != null) {
      data['last_name'] = lastName;
    }
    return data;
  }
}

class ForgotPasswordRequest {
  String? email;

  ForgotPasswordRequest({this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    return data;
  }
}
