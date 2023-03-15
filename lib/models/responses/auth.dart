/// Classes generated using: https://javiercbk.github.io/json_to_dart/

class AuthDataResponse {
  final UserInfo userInfo;
  final String token;
  final DateTime expiryDate;

  AuthDataResponse({
    required this.userInfo,
    required this.token,
    required this.expiryDate,
  });

  factory AuthDataResponse.fromJson(Map<String, dynamic> json) =>
      AuthDataResponse(
        userInfo: UserInfo.fromJson(json["user_info"]),
        token: json["token"],
        expiryDate: DateTime.parse(json["expiry_date"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_info'] = userInfo.toJson();
    data['token'] = token;
    data['expiry_date'] = expiryDate.toIso8601String();
    return data;
  }
}

class UserInfo {
  final int id;
  final String email;
  String firstName;
  String lastName;


  UserInfo({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json['id'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
