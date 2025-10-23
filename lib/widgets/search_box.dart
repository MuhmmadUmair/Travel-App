import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.2, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search for cities or places...',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (_) => onSearch(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: onSearch,
            ),
          ],
        ),
      ),
    );
  }
}
