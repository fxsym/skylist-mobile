import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skylist_mobile/services/todo_services.dart';

class EditTodoScreen extends StatefulWidget {
  final Map<String, dynamic> todoData;

  const EditTodoScreen({Key? key, required this.todoData}) : super(key: key);

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;

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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todoData['title']);
    descriptionController = TextEditingController(
      text: widget.todoData['description'],
    );
    status = widget.todoData['status'] ?? "Not started";
    categories =
        (widget.todoData['categories'] as List)
            .map((cat) => cat['id'] as int)
            .toList();
  }

  void handleUpdate() async {
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
        final response = await TodoService().updateTodo(
          widget.todoData['id'],
          titleController.text,
          descriptionController.text,
          status,
          categories,
        );

        print(response);

        // Ambil data terbaru
        final todos = await TodoService().getTodos();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('todos', jsonEncode(todos));

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Todo updated successfully!')));

        Navigator.pushNamed(context, '/todo/${widget.todoData['id']}');
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
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit to-do'),
        backgroundColor: Colors.blue[400],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Title is required'
                            : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Description is required'
                            : null,
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
                    <String>['Not started', 'In progress', 'Completed'].map((
                      String value,
                    ) {
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
                      final isChecked = categories.contains(category['value']);
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
                onPressed: handleUpdate,
                child: Text('Update'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
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
