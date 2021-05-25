
class User {

  const User({this.userName});

  final String userName;

  User copyWith({String userName}) => User(userName: userName ?? this.userName);

  factory User.fromMap(Map<String, dynamic> json) => User(
      userName: json['user_name'] == null ? null : json['user_name']
  );

  Map<String, dynamic> toMap() => {
    'user_name': userName == null ? null : userName
  };

}