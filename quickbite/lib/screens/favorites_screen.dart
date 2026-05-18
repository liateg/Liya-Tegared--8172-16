import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('My Favorites'), elevation: 0),
          body: provider.favorites.isEmpty
              ? const Center(child: Text('No favorites yet'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.favorites.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final recipe = provider.favorites[i];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(recipe.image),
                      ),
                      title: Text(recipe.name),
                      subtitle: Text(
                        '${recipe.cookTimeMinutes}m • ${recipe.rating}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () => provider.toggleFavorite(recipe),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
