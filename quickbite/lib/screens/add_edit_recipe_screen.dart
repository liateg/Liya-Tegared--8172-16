import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/recipe_model.dart';
import '../providers/recipe_provider.dart';

class AddEditRecipeScreen extends StatefulWidget {
  final Recipe? recipe;

  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  State<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends State<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _timeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _ratingController = TextEditingController(text: '4.5');
  final _reviewController = TextEditingController(text: '0');

  String _cuisine = 'Italian';
  String _difficulty = 'Easy';

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    _timeController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _ratingController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();
    final isEdit = widget.recipe != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Recipe' : 'Create New Recipe'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Share your culinary masterpiece with the world.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: 'Recipe Name',
                    hint: 'e.g. Summer Truffle Pasta',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Cover Image URL',
                    hint: 'https://example.com/image.jpg',
                    controller: _imageController,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Cuisine Type',
                    value: _cuisine,
                    items: const ['Italian', 'Mexican', 'Asian', 'American'],
                    onChanged: (value) =>
                        setState(() => _cuisine = value ?? 'Italian'),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField(
                    label: 'Difficulty',
                    value: _difficulty,
                    items: const ['Easy', 'Medium', 'Hard'],
                    onChanged: (value) =>
                        setState(() => _difficulty = value ?? 'Easy'),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Cooking Time (minutes)',
                    hint: '30',
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Rating',
                    hint: '4.5',
                    controller: _ratingController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Review Count',
                    hint: '0',
                    controller: _reviewController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildMultilineField(
                    label: 'Ingredients',
                    hint:
                        'Enter one ingredient per line...\n200g Fresh Pasta\n2 tbsp Olive Oil...',
                    controller: _ingredientsController,
                  ),
                  const SizedBox(height: 16),
                  _buildMultilineField(
                    label: 'Instructions',
                    hint:
                        'Step 1: Boil salted water...\nStep 2: Sauté the garlic until fragrant...',
                    controller: _instructionsController,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => _saveRecipe(provider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Recipe',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    if (r != null) {
      _nameController.text = r.name;
      _imageController.text = r.image;
      _timeController.text = r.cookTimeMinutes.toString();
      _ingredientsController.text = r.ingredients.join('\n');
      _instructionsController.text = r.instructions.join('\n');
      _ratingController.text = r.rating.toString();
      _reviewController.text = r.reviewCount.toString();
      _cuisine = r.cuisine;
      _difficulty = r.difficulty;
    }
  }

  Future<void> _saveRecipe(RecipeProvider provider) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final ingredients = _ingredientsController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final instructions = _instructionsController.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final isEdit = widget.recipe != null;

    final recipe = Recipe(
      id: isEdit ? widget.recipe!.id : DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text.trim(),
      ingredients: ingredients,
      instructions: instructions,
      prepTimeMinutes: int.tryParse(_timeController.text.trim()) ?? 30,
      cookTimeMinutes: int.tryParse(_timeController.text.trim()) ?? 30,
      servings: 2,
      difficulty: _difficulty,
      cuisine: _cuisine,
      caloriesPerServing: 300,
      tags: [_cuisine, _difficulty],
      userId: 1,
      image: _imageController.text.trim().isEmpty
          ? 'https://cdn.dummyjson.com/recipe-images/1.webp'
          : _imageController.text.trim(),
      rating: double.tryParse(_ratingController.text.trim()) ?? 4.5,
      reviewCount: int.tryParse(_reviewController.text.trim()) ?? 0,
      mealType: const ['Dinner'],
    );

    if (isEdit) {
      await provider.updateRecipe(recipe);
    } else {
      await provider.addRecipe(recipe);
    }

    if (!mounted) return;

    if (provider.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.error!)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recipe saved')));

    if (!isEdit) {
      _formKey.currentState?.reset();
      _nameController.clear();
      _imageController.clear();
      _timeController.clear();
      _ingredientsController.clear();
      _instructionsController.clear();
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.teal, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final dropdownItems = List<String>.from(items);
    if (!dropdownItems.contains(value)) {
      dropdownItems.add(value);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            value: value,
            items: dropdownItems
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildMultilineField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),
      ],
    );
  }
}
