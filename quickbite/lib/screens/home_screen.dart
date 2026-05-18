import 'package:flutter/material.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Recipe> sample;

  @override
  void initState() {
    super.initState();
    sample = [
      Recipe(
        id: 1,
        name: 'Spicy Salmon',
        ingredients: ['Salmon fillet', 'Chili flakes', 'Garlic', 'Lemon'],
        instructions: ['Preheat oven', 'Season salmon', 'Bake at 400F for 15 mins'],
        prepTimeMinutes: 10,
        cookTimeMinutes: 15,
        servings: 2,
        difficulty: 'Medium',
        cuisine: 'Asian',
        caloriesPerServing: 350,
        tags: ['Healthy', 'Seafood'],
        userId: 1,
        image: 'https://cdn.dummyjson.com/recipe-images/1.webp',
        rating: 4.8,
        reviewCount: 24,
        mealType: ['Dinner'],
      ),
      Recipe(
        id: 2,
        name: 'Quinoa Power Bowl',
        ingredients: ['Quinoa', 'Chickpeas', 'Kale', 'Tahini dressing'],
        instructions: ['Cook quinoa', 'Roast chickpeas', 'Assemble bowl'],
        prepTimeMinutes: 15,
        cookTimeMinutes: 20,
        servings: 1,
        difficulty: 'Easy',
        cuisine: 'Healthy',
        caloriesPerServing: 450,
        tags: ['Vegan', 'Protein-packed'],
        userId: 2,
        image: 'https://cdn.dummyjson.com/recipe-images/2.webp',
        rating: 4.6,
        reviewCount: 18,
        mealType: ['Lunch'],
      ),
      Recipe(
        id: 3,
        name: 'Heirloom Salad',
        ingredients: ['Tomatoes', 'Basil', 'Burrata', 'Olive oil', 'Balsamic'],
        instructions: ['Slice tomatoes', 'Add basil', 'Top with burrata', 'Drizzle dressing'],
        prepTimeMinutes: 10,
        cookTimeMinutes: 0,
        servings: 2,
        difficulty: 'Easy',
        cuisine: 'Italian',
        caloriesPerServing: 280,
        tags: ['Keto', 'Fresh', 'Vegetarian'],
        userId: 3,
        image: 'https://cdn.dummyjson.com/recipe-images/3.webp',
        rating: 4.9,
        reviewCount: 32,
        mealType: ['Lunch'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickBite'),
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search recipes...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
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
                    ChoiceChip(label: const Text('All'), selected: true, onSelected: (_) {}),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Italian'), selected: false, onSelected: (_) {}),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Mexican'), selected: false, onSelected: (_) {}),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Asian'), selected: false, onSelected: (_) {}),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Feeling adventurous?', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 6),
                            Text('Let us pick a random recipe for you.'),
                          ],
                        ),
                      ),
                      ElevatedButton(onPressed: () {}, child: const Text('Surprise Me'))
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
                itemCount: sample.length,
                itemBuilder: (context, i) {
                  final recipe = sample[i];
                  return RecipeCard(
                    recipe: recipe,
                    isFavorite: i == 0,
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
  }
}
