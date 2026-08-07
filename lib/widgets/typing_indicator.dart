import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({
    super.key,
  });

  @override
  State<TypingIndicator> createState() =>
      _TypingIndicatorState();
}

class _TypingIndicatorState
    extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(
      double begin,
      ) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.3,
        end: 1,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            begin,
            begin + 0.3,
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: Container(
        width: 8,
        height: 8,
        margin:
        const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        decoration:
        const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 18,
            child: Icon(
              Icons.smart_toy,
            ),
          ),

          const SizedBox(width: 10),

          Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius:
              BorderRadius.circular(
                20,
              ),
            ),
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [

                _dot(0.0),

                _dot(0.2),

                _dot(0.4),

              ],
            ),
          ),
        ],
      ),
    );
  }
}