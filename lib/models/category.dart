class Category {
  final int id;
  final int userId;
  final String categoryName;
  final String description;

  Category({
    required this.id,
    required this.userId,
    required this.categoryName,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      userId: int.parse(json['user_id'].toString()),
      categoryName: json['category_name'],
      description: json['description'],
    );
  }
}
