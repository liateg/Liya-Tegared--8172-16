import 'package:flutter/foundation.dart';

import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeProvider({RecipeService? service})
    : _service = service ?? RecipeService();

  final RecipeService _service;

  bool _isLoading = false;
  String? _error;
  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  final Set<int> _deletedRecipeIds = {}; // Track deleted recipe IDs because DummyJSON only simulates deletion.

  // DummyJSON create endpoints return mock objects that are not persisted.
  // IDs above the seeded range are treated as local-only for fallback updates/deletes.
  bool _isLikelyLocalMockId(int id) => id > 150;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<Recipe> get favorites => List.unmodifiable(_favorites);

  Future<void> loadRecipes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetched = await _service.fetchRecipes();
      _recipes = fetched.where((recipe) => !_deletedRecipeIds.contains(recipe.id)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshRecipes() async => loadRecipes();

  Future<void> search(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (query.trim().isEmpty) {
        final fetched = await _service.fetchRecipes();
        _recipes = fetched.where((recipe) => !_deletedRecipeIds.contains(recipe.id)).toList();
      } else {
        final fetched = await _service.searchRecipes(query);
        _recipes = fetched.where((recipe) => !_deletedRecipeIds.contains(recipe.id)).toList();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Recipe? recipeById(int id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _service.createRecipe(recipe);
      _recipes = [created, ..._recipes];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRecipe(Recipe recipe) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updated = await _service.updateRecipe(recipe);
      _recipes = _recipes
          .map((item) => item.id == updated.id ? updated : item)
          .toList();
      _favorites = _favorites
          .map((item) => item.id == updated.id ? updated : item)
          .toList();
    } catch (e) {
      final existsLocally = _recipes.any((item) => item.id == recipe.id);
      if (existsLocally && _isLikelyLocalMockId(recipe.id)) {
        _recipes = _recipes
            .map((item) => item.id == recipe.id ? recipe : item)
            .toList();
        _favorites = _favorites
            .map((item) => item.id == recipe.id ? recipe : item)
            .toList();
        _error = null;
      } else {
        _error = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRecipe(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _deletedRecipeIds.add(id); // Remember that this is deleted
      await _service.deleteRecipe(id);
      _recipes.removeWhere((recipe) => recipe.id == id);
      _favorites.removeWhere((recipe) => recipe.id == id);
    } catch (e) {
      final existsLocally = _recipes.any((recipe) => recipe.id == id);
      if (existsLocally && _isLikelyLocalMockId(id)) {
        _recipes.removeWhere((recipe) => recipe.id == id);
        _favorites.removeWhere((recipe) => recipe.id == id);
        _error = null;
      } else {
        _error = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(Recipe recipe) {
    final existingIndex = _favorites.indexWhere((item) => item.id == recipe.id);
    if (existingIndex >= 0) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(recipe);
    }
    notifyListeners();
  }

  bool isFavorite(int recipeId) {
    return _favorites.any((recipe) => recipe.id == recipeId);
  }
}
