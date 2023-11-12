import 'package:app/ui/style/style.dart';
import 'package:flutter/material.dart';

class LikeSelect extends StatelessWidget {
  final String title;
  final bool isLiked;
  final ValueChanged<bool>? onChanged;

  const LikeSelect(
    this.title,
    this.isLiked, {
    super.key,
    this.onChanged,
  });

  Widget buildMenuRow() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextHeadline(title.toUpperCase()),
          ],
        ));
  }

  Widget buildContentRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (onChanged != null) {
                onChanged!(!isLiked);
              }
            },
            child: Icon(
              (isLiked) ? Icons.favorite : Icons.favorite_outline,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMenuRow(),
        buildContentRow(context),
      ],
    );
  }
}
