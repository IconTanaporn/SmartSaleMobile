import 'package:flutter/cupertino.dart';

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;

  const ExpandedSection({
    Key? key,
    this.expand = false,
    required this.child,
  }) : super(key: key);

  @override
  State<ExpandedSection> createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: -1,
      sizeFactor: CurvedAnimation(
        parent: expandController,
        curve: Curves.fastOutSlowIn,
      ),
      child: widget.child,
    );
  }
}
