import 'dart:ui';

import 'package:flutter/material.dart';

/// Smooth fade + subtle upward-lift transition used for all navbar navigation.
Route<dynamic> navRoute(Widget page) {
  return PageRouteBuilder<dynamic>(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (_, animation, __, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

class FloatingNavBar extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _scaleControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _scaleControllers = List.generate(
      widget.items.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
    _scaleAnimations = _scaleControllers.map((c) {
      return Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: c, curve: Curves.easeOutBack),
      );
    }).toList();
    if (widget.selectedIndex >= 0 && widget.selectedIndex < _scaleControllers.length) {
      _scaleControllers[widget.selectedIndex].forward();
    }
  }

  @override
  void didUpdateWidget(FloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      if (oldWidget.selectedIndex >= 0 && oldWidget.selectedIndex < _scaleControllers.length) {
        _scaleControllers[oldWidget.selectedIndex].reverse();
      }
      if (widget.selectedIndex >= 0 && widget.selectedIndex < _scaleControllers.length) {
        _scaleControllers[widget.selectedIndex].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _scaleControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.62),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.09),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.38),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: gold.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slotWidth = constraints.maxWidth / widget.items.length;

                final hasActive = widget.selectedIndex >= 0 &&
                    widget.selectedIndex < widget.items.length;

                return SizedBox(
                  height: 52,
                  child: Stack(
                    children: [
                      // Sliding active pill — hidden when selectedIndex < 0
                      if (hasActive)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          left: widget.selectedIndex * slotWidth + 4,
                          width: slotWidth - 8,
                          top: 4,
                          bottom: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  gold.withOpacity(0.24),
                                  gold.withOpacity(0.09),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: gold.withOpacity(0.45),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: gold.withOpacity(0.22),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Nav items
                      Row(
                        children: List.generate(widget.items.length, (index) {
                          final item = widget.items[index];
                          return _NavItem(
                            icon: item["icon"] as IconData,
                            label: item["label"] as String,
                            isActive: hasActive && widget.selectedIndex == index,
                            isCart: item["label"] == "Cart",
                            slotWidth: slotWidth,
                            scaleAnimation: _scaleAnimations[index],
                            onTap: () => widget.onItemTapped(index),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCart;
  final double slotWidth;
  final Animation<double> scaleAnimation;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCart,
    required this.slotWidth,
    required this.scaleAnimation,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _tapAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _tapAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) => _tapController.forward();
  void _handleTapUp(TapUpDetails _) {
    _tapController.reverse();
    widget.onTap();
  }
  void _handleTapCancel() => _tapController.reverse();

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE0B43A);
    const inactive = Color(0xFF6B7280);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: SizedBox(
        width: widget.slotWidth,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: Listenable.merge([_tapAnimation, widget.scaleAnimation]),
          builder: (context, child) => Transform.scale(
            scale: _tapAnimation.value *
                (widget.isActive ? widget.scaleAnimation.value : 1.0),
            child: child,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.isActive)
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: gold.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        widget.isCart
                            ? (widget.isActive
                                ? Icons.shopping_cart
                                : Icons.shopping_cart_outlined)
                            : widget.icon,
                        key: ValueKey('${widget.label}_${widget.isActive}'),
                        color: widget.isActive ? gold : inactive,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                // Label: TweenAnimationBuilder drives width + fade + slide
                // simultaneously without extra controllers (web-safe).
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: widget.isActive ? 1.0 : 0.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, child) {
                    return ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: v,
                        child: Opacity(
                          opacity: v,
                          child: Transform.translate(
                            offset: Offset(-10.0 * (1.0 - v), 0),
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
