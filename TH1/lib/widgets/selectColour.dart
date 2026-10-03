import 'package:flutter/material.dart';

import '../colors.dart';

// Hàng chọn màu, dùng cho môn học và màu chủ đạo
class SelectColour extends StatelessWidget {
  const SelectColour({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final colour in selectableColours)
          InkWell(
            key: ValueKey('colour-$colour'),
            customBorder: const CircleBorder(),
            onTap: () => onSelected(colour),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colorFromString(colour),
              child: colour == selected
                  ? const Icon(Icons.check_rounded, color: Colors.white)
                  : null,
            ),
          ),
      ],
    );
  }
}
