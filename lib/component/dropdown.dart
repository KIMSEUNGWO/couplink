

import 'package:flutter/material.dart';

class Dropdown {

  static void show<T>(BuildContext context, {
  required List<T> items,
  required Widget Function(T item) builder,
  T? initItem,
  Function(T item)? onSelected,
  double itemHeight = 50,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: items.length * itemHeight + 100,
          child: Column(
            children: [
              Container(
                width: 50, height: 4,
                color: const Color(0xFFE5E6EB),
              ),
              const SizedBox(height: 20,),

              ...items.map((item) {
                return GestureDetector(
                  onTap: () {
                    if (onSelected != null) {
                      onSelected(item);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: itemHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: initItem == item ? const Color(0xFFF8F9FA) : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: builder(item)
                  ),
                );
              })
            ],
          ),
        );
      },
    );
  }
}