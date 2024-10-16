import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    super.key,
    required this.categories,
    this.selectedCategory,
  });

  final Map<String, bool> categories;
  final String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
