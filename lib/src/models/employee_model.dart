import 'dart:convert';

List<Employee> employeeFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;
  String age;
  String gender;

  Employee({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.age,
    required this.gender,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"],
        age: json["age"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar,
        "age": age,
        "gender": gender,
      };
}
