import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
	const FavoritesScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final favorites = [
			{'title': 'Fresh Avocado Bowl', 'subtitle': '10m • 4.8', 'image': ''},
			{'title': 'Classic Genovese', 'subtitle': '25m • 4.6', 'image': ''},
			{'title': 'Wild Berry Cloud', 'subtitle': '8m • 5.0', 'image': ''},
		];

		return Scaffold(
			appBar: AppBar(
				title: const Text('My Favorites'),
				elevation: 0,
			),
			body: ListView.separated(
				padding: const EdgeInsets.all(16),
				itemCount: favorites.length,
				separatorBuilder: (_, __) => const SizedBox(height: 10),
				itemBuilder: (context, i) {
					final item = favorites[i];
					return ListTile(
						leading: CircleAvatar(
							radius: 26,
							backgroundImage: AssetImage('assets/image.png'),
						),
						title: Text(item['title']!),
						subtitle: Text(item['subtitle']!),
						trailing: Icon(Icons.favorite, color: Colors.red),
						onTap: () {},
					);
				},
			),
		);
	}
}
