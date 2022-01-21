import 'package:api_to_sqlite/src/models/employee_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  List<dynamic> _employees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('API to SQLite'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              tooltip: 'Load from API',
              icon: const Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
            IconButton(
              tooltip: 'Delete all',
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
            IconButton(
              tooltip: 'Add Employee',
              icon: const Icon(Icons.add),
              onPressed: () async {
                await _addEmployee();
              },
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildEmployeeListView());
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // ignore: avoid_print
    print('All employees deleted');
  }

  _addEmployee() async {
    _showAlertDialog(context);
  }

  _showAlertDialog(BuildContext context) {
    String email = '',
        firstName = '',
        lastName = '',
        avatarUrl = '',
        age = '',
        gender = '';

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    Widget addButton = TextButton(
      child: const Text("Add"),
      onPressed: () {
        if (email.isEmpty) email = 'b1battledroid@empire.net';
        if (firstName.isEmpty) firstName = 'B1';
        if (lastName.isEmpty) lastName = 'Battle Droid';
        if (avatarUrl.isEmpty) {
          avatarUrl = 'https://game-assets.swgoh.gg/tex.charui_b1.png';
        }
        if (age.isEmpty) age = '0';
        if (gender.isEmpty) gender = 'Robot';

        Employee employee = Employee(
            id: _employees.length + 100,
            email: email,
            firstName: firstName,
            lastName: lastName,
            avatar: avatarUrl,
            age: age,
            gender: gender);
        DBProvider.db.createEmployee(employee);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Add Employee'),
      content: ListView(
        children: [
          const Text('If you do not add values, default ones will be applied!'),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
            onChanged: (String input) {
              email = input;
            },
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'First name',
            ),
            onChanged: (String input) {
              firstName = input;
            },
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Last name',
            ),
            onChanged: (String input) {
              lastName = input;
            },
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Avatar url',
            ),
            onChanged: (String input) {
              avatarUrl = input;
            },
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Age',
            ),
            onChanged: (String input) {
              age = input;
            },
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Gender',
            ),
            onChanged: (String input) {
              gender = input;
            },
          ),
        ],
      ),
      actions: [
        cancelButton,
        addButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) async {
      setState(() => isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);
    });
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          _employees = snapshot.data;
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(snapshot.data[index].avatar),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                            "Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName}"),
                        Text('Email: ${snapshot.data[index].email}'),
                        Text('Age: ${snapshot.data[index].age}'),
                        Text('Gender: ${snapshot.data[index].gender}'),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
