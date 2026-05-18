import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/recipe_card.dart';
import '../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCuisine = 'All';

  void _openRandomRecipe(RecipeProvider provider) {
    final list = [...provider.recipes];
    if (list.isEmpty) {
      provider.loadRecipes();
      return;
    }

    list.shuffle();
    final pick = list.first;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetailScreen(recipe: pick)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('QuickBite'),
            elevation: 0,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () => provider.loadRecipes(),
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () => _openRandomRecipe(provider),
                icon: const Icon(Icons.shuffle),
                tooltip: 'Surprise Me',
              ),
            ],
          ),
          body: SafeArea(
            child: provider.isLoading && provider.recipes.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null && provider.recipes.isEmpty
                    ? Center(child: Text(provider.error!))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                onSubmitted: (val) => provider.search(val),
                                decoration: InputDecoration(
                                  hintText: 'Search recipes...',
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => provider.loadRecipes(),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 44,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                children: [
                                  ChoiceChip(
                                    label: const Text('All'),
                                    selected: _selectedCuisine == 'All',
                                    onSelected: (_) => setState(() => _selectedCuisine = 'All'),
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChip(
                                    label: const Text('Italian'),
                                    selected: _selectedCuisine == 'Italian',
                                    onSelected: (_) => setState(() => _selectedCuisine = 'Italian'),
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChip(
                                    label: const Text('Mexican'),
                                    selected: _selectedCuisine == 'Mexican',
                                    onSelected: (_) => setState(() => _selectedCuisine = 'Mexican'),
                                  ),
                                  const SizedBox(width: 8),
                                  ChoiceChip(
                                    label: const Text('Asian'),
                                    selected: _selectedCuisine == 'Asian',
                                    onSelected: (_) => setState(() => _selectedCuisine = 'Asian'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.teal[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Feeling adventurous?', style: TextStyle(fontWeight: FontWeight.bold)),
                                          SizedBox(height: 6),
                                          Text('Let us pick a random recipe for you.'),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _openRandomRecipe(provider),
                                      child: const Text('Surprise Me'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Popular Recipes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text('View All', style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _selectedCuisine == 'All'
                                  ? provider.recipes.length
                                  : provider.recipes.where((r) => r.cuisine.toLowerCase() == _selectedCuisine.toLowerCase()).length,
                              itemBuilder: (context, i) {
                                final displayed = _selectedCuisine == 'All'
                                    ? provider.recipes
                                    : provider.recipes.where((r) => r.cuisine.toLowerCase() == _selectedCuisine.toLowerCase()).toList();
                                final recipe = displayed[i];
                                return RecipeCard(
                                  recipe: recipe,
                                  isFavorite: provider.isFavorite(recipe.id),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeDetailScreen(recipe: recipe),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
