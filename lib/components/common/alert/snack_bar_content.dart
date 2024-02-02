import 'package:flutter/material.dart';

import '../../../config/constant.dart';
import '../text/text.dart';

class SnackBarContent extends StatefulWidget {
  final String label, text;
  final Color color, backgroundColor;

  const SnackBarContent({
    Key? key,
    this.label = '',
    this.text = '',
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  State<SnackBarContent> createState() => SnackBarContentState();
}

class SnackBarContentState extends State<SnackBarContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 100,
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[1],
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: widget.color,
            size: 50,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  widget.label,
                  color: widget.color,
                  fontSize: FontSize.title,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                CustomText(
                  widget.text,
                  color: widget.color,
                  lineOfNumber: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
