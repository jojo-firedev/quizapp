import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.categories,
    this.selectedCategory,
  });

  final Map<String, bool> categories;
  final String? selectedCategory;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 40.0, end: 70.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCirc,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.categories.keys.map((key) {
            bool value = widget.categories[key]!;

            // Prüfen, ob der Text mit der `selectedCategory` übereinstimmt
            bool isSelected = widget.selectedCategory != null &&
                key == widget.selectedCategory;

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    key,
                    style: TextStyle(
                      fontSize: isSelected ? _animation.value : 40,
                      fontWeight: FontWeight.w500,
                      color: value ? Colors.grey : Colors.black,
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
