import 'package:flutter/material.dart';

class FadeListMask extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;

  const FadeListMask({
    Key? key,
    required this.child,
    this.top = true,
    this.bottom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.purple,
            Colors.transparent,
            Colors.transparent,
            Colors.purple
          ],
          stops: [0, top ? 0.06 : 0, bottom ? 0.95 : 1, 1],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}
