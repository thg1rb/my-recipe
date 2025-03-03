class FoodRecipe {
  String _title;
  String _image;
  String _difficulty;
  String _category;
  String _description;
  List<String> _ingredients;
  String _instruction;
  int _likes;
  

  FoodRecipe({
    required String title,
    required String image,
    required String difficulty,
    required String category,
    required int likes,
    required String description,
    required List<String> ingredients, 
    required String instruction,
  })  : _title = title,
        _image = image,
        _difficulty = difficulty,
        _category = category,
        _likes = likes,
        _description = description,
        _ingredients = ingredients,
        _instruction = instruction;
  

  factory FoodRecipe.fromMap(Map<String, dynamic> map) {
    return FoodRecipe(
      title: map['title'],
      image: map['imageUrl'],
      difficulty: map['difficulty'],
      category: map['category'],
      likes: map['like'],
      description: map['description'],
      ingredients: map['ingredients'],
      instruction: map['instruction'],
    );
  }

  // Getters
  String get title => _title;
  String get image => _image;
  String get difficulty => _difficulty;
  String get category => _category;
  int get likes => _likes;
  String get description => _description;
  List<String> get ingredients => _ingredients;
  String get instruction => _instruction;



  // Setters
  set title(String value) {
    _title = value;
  }

  set image(String value) {
    _image = value;
  }

  set difficulty(String value) {
    _difficulty = value;
  }

  set likes(int value) {
    _likes = value;
  }
  set category(String value) {
    _category = value;
  }
}