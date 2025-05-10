import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skylist_mobile/services/todo_services.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>(); // Added Form key for validation
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String status = "Not started";
  List<int> categories = [];
  bool nullCategories = false;
  bool loading = false;

  List<Map<String, dynamic>> dataCategories = [
    {'label': 'Task', 'value': 1},
    {'label': 'Work', 'value': 2},
    {'label': 'Study', 'value': 3},
    {'label': 'Personal', 'value': 4},
    {'label': 'Money', 'value': 5},
    {'label': 'Social', 'value': 6},
    {'label': 'Health', 'value': 7},
    {'label': 'Hobby', 'value': 8},
    {'label': 'Productivity', 'value': 9},
  ];

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
        nullCategories = categories.isEmpty;
      });

      if (nullCategories) {
        setState(() {
          loading = false;
        });
        return;
      }

      try {
        final response = await TodoService().createTodo(
          titleController.text,
          descriptionController.text,
          status,
          categories,
        );

        print(response);
        // Jika berhasil, ambil data todos terbaru
        final todos = await TodoService().getTodos();

        // Simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('todos', jsonEncode(todos));

        // Optional: tampilkan snackbar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Todo created successfully!')));

        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new to-do'),
        backgroundColor: Colors.blue[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Wrapping with Form widget
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Status'),
              DropdownButton<String>(
                value: status,
                onChanged: (String? newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
                items:
                    <String>[
                      'Not started',
                      'In progress',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
              Text('Categories'),
              if (nullCategories)
                Text(
                  'You must choose at least 1 category',
                  style: TextStyle(color: Colors.red),
                ),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    dataCategories.map((category) {
                      bool isChecked = categories.contains(category['value']);
                      return FilterChip(
                        label: Text(category['label']),
                        selected: isChecked,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              categories.add(category['value']);
                            } else {
                              categories.remove(category['value']);
                            }
                          });
                        },
                        backgroundColor: Colors.blue[400],
                        selectedColor: Colors.blue[800],
                        labelStyle: TextStyle(color: Colors.white),
                      );
                    }).toList(),
              ),
              if (loading) Center(child: CircularProgressIndicator()),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text('Create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors
                          .blue[400], // Use backgroundColor instead of primary
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
