class CategoryNameModel {
  final String? name;

  CategoryNameModel({this.name});

  factory CategoryNameModel.fromJson(Map<String, dynamic> json) {
    return CategoryNameModel(
      name: json['name'], // Must match the key in your JSON exactly
    );
  }
}