import 'package:api_to_sqlite/src/models/employee_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class EmployeeApiProvider {
  Future<List<Employee?>> getAllEmployees() async {
    var url = "https://www.mockachino.com/8a7c1ba0-0087-4b/employees";
    Response response = await Dio().get(url);

    return (response.data["body"] as List).map((employee) {
      DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}
