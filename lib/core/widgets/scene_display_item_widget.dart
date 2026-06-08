import 'package:flutter/material.dart';
import '../models/display_item_group.dart';
import '../utils/sfx_service.dart';

class SceneDisplayItemWidget extends StatefulWidget {
  final DisplayItemData data;
  final double size;

  const SceneDisplayItemWidget({
    super.key,
    required this.data,
    required this.size,
  });

  @override
  State<SceneDisplayItemWidget> createState() => _SceneDisplayItemWidgetState();
}

class _SceneDisplayItemWidgetState extends State<SceneDisplayItemWidget>
    with TickerProviderStateMixin {
  late final AnimationController _breathCtrl;
  late final Animation<double> _breathAnim;
  late final AnimationController _wobbleCtrl;
  late final Animation<double> _wobbleAnim;

  @override
  void initState() {
    super.initState();

    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _breathAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut),
    );

    _wobbleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _wobbleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.00, end:  0.10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.10, end: -0.10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.10, end: 0.06), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.06, end: -0.04), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.04, end: 0.00), weight: 1),
    ]).animate(_wobbleCtrl);
  }

  @override
  void dispose() {
    _breathCtrl.dispose();
    _wobbleCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    SfxService().itemTap();
    _wobbleCtrl.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathCtrl, _wobbleCtrl]),
        builder: (context, child) {
          return Transform.rotate(
            angle: _wobbleAnim.value,
            child: Transform.scale(
              scale: _breathAnim.value,
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: Image.asset(
            widget.data.asset,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, st) => _Placeholder(
              size: widget.size,
              group: widget.data.group,
            ),
          ),
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double size;
  final DisplayItemGroup group;

  const _Placeholder({required this.size, required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.5,
        ),
        color: Colors.black.withValues(alpha: 0.15),
      ),
      child: Icon(
        _icon(group),
        color: Colors.white.withValues(alpha: 0.7),
        size: size * 0.48,
      ),
    );
  }

  IconData _icon(DisplayItemGroup g) => switch (g) {
    DisplayItemGroup.schedule   => Icons.task_alt,
    DisplayItemGroup.diary      => Icons.book_outlined,
    DisplayItemGroup.breathing  => Icons.air,
    DisplayItemGroup.sleep      => Icons.bedtime_outlined,
    DisplayItemGroup.garden     => Icons.eco_outlined,
    DisplayItemGroup.aquarium   => Icons.water_drop_outlined,
    DisplayItemGroup.painting   => Icons.brush_outlined,
    DisplayItemGroup.music      => Icons.music_note_outlined,
    DisplayItemGroup.engagement => Icons.people_outline,
    DisplayItemGroup.score      => Icons.star_outline,
  };
}
