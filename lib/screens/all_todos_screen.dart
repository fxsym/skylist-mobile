import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skylist_mobile/components/todo_list_section.dart';
import 'package:skylist_mobile/models/todo_model.dart';
import '../providers/todo_provider.dart';

class AllTodosScreen extends StatefulWidget {
  const AllTodosScreen({super.key});

  @override
  State<AllTodosScreen> createState() => _AllTodosScreenState();
}

class _AllTodosScreenState extends State<AllTodosScreen> {
  String keyword = '';
  String selectedStatus = '';
  String selectedCategory = '';
  String selectedDate = ''; // yyyy-MM-dd
  bool loading = false;
  bool searchLoading = false;

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<TodoProvider>().todos;

    // ------- FILTER LOGIC -------
    final List<TodoModel> filteredTodos =
        todos.where((todo) {
          final matchesKeyword = todo.title.toLowerCase().contains(
            keyword.toLowerCase(),
          );
          final matchesStatus =
              selectedStatus.isEmpty || todo.status == selectedStatus;
          final matchesCategory =
              selectedCategory.isEmpty ||
              todo.categories.any((c) => c.id.toString() == selectedCategory);
          final matchesDate =
              selectedDate.isEmpty ||
              todo.createdAt.split(' | ').first == selectedDate;

          return matchesKeyword &&
              matchesStatus &&
              matchesCategory &&
              matchesDate;
        }).toList();
    // ----------------------------

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All your to-dos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // ---------- SEARCH ----------
            const SizedBox(height: 16),
            TextField(
              onChanged: (v) => setState(() => keyword = v),
              decoration: InputDecoration(
                hintText: 'Search To-dos By Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon:
                    searchLoading ? const CircularProgressIndicator() : null,
              ),
            ),

            // ---------- FILTERS ----------
            const SizedBox(height: 16),
            Row(
              children: [
                // Status
                DropdownButton<String>(
                  value: selectedStatus.isEmpty ? null : selectedStatus,
                  hint: const Text('Choose Status'),
                  onChanged: (v) => setState(() => selectedStatus = v ?? ''),
                  items:
                      const ['', 'Not started', 'In progress', 'Completed']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(v.isEmpty ? 'All' : v),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(width: 16),
                // Category
                DropdownButton<String>(
                  value: selectedCategory.isEmpty ? null : selectedCategory,
                  hint: const Text('Choose Category'),
                  onChanged: (v) => setState(() => selectedCategory = v ?? ''),
                  items:
                      const ['', '1', '2', '3', '4', '5', '6', '7', '8', '9']
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Text(v.isEmpty ? 'All' : v),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(width: 16),
                // Date picker + clear
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(
                              () =>
                                  selectedDate = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(picked),
                            );
                          }
                        },
                        child: AbsorbPointer(
                          child: TextField(
                            controller: TextEditingController(
                              text: selectedDate,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Select Date',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      if (selectedDate.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => selectedDate = ''),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // ---------- LIST ----------
            const SizedBox(height: 16),
            if (filteredTodos.isEmpty)
              const Center(child: Text('No to-dos found'))
            else
              TodoListWidget(todos: filteredTodos),

            // ---------- ADD BUTTON ----------
            // const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, '/add-todo');
            //   },
            //   child: const Text('Add New Todo'),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-todo');
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
