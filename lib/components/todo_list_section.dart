import 'package:flutter/material.dart';
import 'package:skylist_mobile/models/todo_model.dart';
import 'status_icons.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoModel> todos;
  final int? maxItems;

  const TodoListWidget({Key? key, required this.todos, this.maxItems}) : super(key: key);

  String truncateText(String text, int wordLimit) {
    final words = text.split(' ');
    return words.length <= wordLimit
        ? text
        : words.sublist(0, wordLimit).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    final displayTodos = maxItems != null && todos.length > maxItems!
        ? todos.sublist(0, maxItems!)
        : todos;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: displayTodos.map((todo) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/todo/${todo.id}');
          },
          child: Container(
            width: MediaQuery.of(context).size.width > 1200
                ? MediaQuery.of(context).size.width * 0.32
                : MediaQuery.of(context).size.width > 768
                    ? MediaQuery.of(context).size.width * 0.45
                    : double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Left content
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        truncateText(todo.description, 8),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Created At: ${todo.createdAt}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children: List<Widget>.from(
                          todo.categories.map((category) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                category.categoriesName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right status icon
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: ClipOval(
                        child: Image.asset(
                          statusIcons[todo.status] ?? 'assets/icons/default.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
