class CategoryModel {
  final int id;
  final String categoriesName;

  CategoryModel({required this.id, required this.categoriesName});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoriesName: json['categories_name'],
    );
  }
}

class TodoModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  final List<CategoryModel> categories;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.categories,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    var categoryList = (json['categories'] as List)
        .map((cat) => CategoryModel.fromJson(cat))
        .toList();

    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'],
      categories: categoryList,
    );
  }
}
