import 'package:flutter/material.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String) onReactionSelected;

  const ReactionPicker({super.key, required this.onReactionSelected});

  @override
  Widget build(BuildContext context) {
    const reactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reactions.length,
        itemBuilder: (context, index) {
          return IconButton(
            icon: Text(reactions[index], style: const TextStyle(fontSize: 24)),
            onPressed: () => onReactionSelected(reactions[index]),
          );
        },
      ),
    );
  }
}