
class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final List<String> instructions;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;
  final List<String> tags;
  final int userId;
  final String image;
  final double rating;
  final int reviewCount;
  final List<String> mealType;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.tags,
    required this.userId,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.mealType,
  });
Recipe copyWith({
  
  String? name,
  List<String>? ingredients,
  List<String>? instructions,
  int? prepTimeMinutes,
  int? cookTimeMinutes,
  int? servings,
  String? difficulty,
  String? cuisine,
  int? caloriesPerServing,
  List<String>? tags,
  int? userId,
  String? image,
  double? rating,
  int? reviewCount,
  List<String>? mealType,
}) {
  return Recipe(
   id:id,
    name: name ?? this.name,
    ingredients: ingredients ?? this.ingredients,
    instructions: instructions ?? this.instructions,
    prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
    cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
    servings: servings ?? this.servings,
    difficulty: difficulty ?? this.difficulty,
    cuisine: cuisine ?? this.cuisine,
    caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
    tags: tags ?? this.tags,
    userId: userId ?? this.userId,
    image: image ?? this.image,
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    mealType: mealType ?? this.mealType,
  );
}
  factory Recipe.fromJson(Map<String, dynamic> json){
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      prepTimeMinutes: json['prepTimeMinutes'],
      cookTimeMinutes: json['cookTimeMinutes'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      cuisine: json['cuisine'],
      caloriesPerServing: json['caloriesPerServing'],
      tags: List<String>.from(json['tags']),
      userId: json['userId'],
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'],
      mealType: List<String>.from(json['mealType']),
    );
  }
  }

// "id": 1,
//   "name": "Classic Margherita Pizza",
//   "ingredients": [
//     "Pizza dough",
//     "Tomato sauce",
//     "Fresh mozzarella cheese",
//     "Fresh basil leaves",
//     "Olive oil",
//     "Salt and pepper to taste"
//   ],
//   "instructions": [
//     "Preheat the oven to 475°F (245°C).",
//     "Roll out the pizza dough and spread tomato sauce evenly.",
//     "Top with slices of fresh mozzarella and fresh basil leaves.",
//     "Drizzle with olive oil and season with salt and pepper.",
//     "Bake in the preheated oven for 12-15 minutes or until the crust is golden brown.",
//     "Slice and serve hot."
//   ],
//   "prepTimeMinutes": 20,
//   "cookTimeMinutes": 15,
//   "servings": 4,
//   "difficulty": "Easy",
//   "cuisine": "Italian",
//   "caloriesPerServing": 300,
//   "tags": [
//     "Pizza",
//     "Italian"
//   ],
//   "userId": 45,
//   "image": "https://cdn.dummyjson.com/recipe-images/1.webp",
//   "rating": 4.6,
//   "reviewCount": 3,
//   "mealType": [
//     "Dinner"
