import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/recipe_model.dart';

class RecipeService {
  RecipeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://dummyjson.com/recipes';

  Future<List<Recipe>> fetchRecipes() async {
    final response = await _client.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> recipesJson =
        data['recipes'] as List<dynamic>? ?? const [];

    return recipesJson
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Recipe> fetchRecipeById(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load recipe details');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Recipe.fromJson(data);
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final uri = Uri.parse('$_baseUrl/search?q=${Uri.encodeComponent(query)}');
    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to search recipes');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> recipesJson =
        data['recipes'] as List<dynamic>? ?? const [];

    return recipesJson
        .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Recipe> createRecipe(Recipe recipe) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(recipe.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create recipe');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Recipe.fromJson(data);
  }

  Future<Recipe> updateRecipe(Recipe recipe) async {
    final body = recipe.toJson();
    body.remove('id'); // Remove id to avoid DummyJSON 404 error

    final response = await _client.put(
      Uri.parse('$_baseUrl/${recipe.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update recipe');
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Recipe.fromJson(data);
  }

  Future<void> deleteRecipe(int id) async {
    final response = await _client.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete recipe');
    }
  }
}
