import 'package:flutter/material.dart';

Widget buildGradientBackground() {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0A0E27),
          Color(0xFF1A1F36),
          Color(0xFF2D3561),
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    ),
  );
}

Widget buildFloatingParticles(
    AnimationController fadeController, Animation<double> fadeAnimation) {
  return Stack(
    children: List.generate(150, (index) {
      return AnimatedBuilder(
        animation: fadeController,
        builder: (context, child) {
          return Positioned(
            left: (index * 50.0) % MediaQuery.of(context).size.width,
            top: (index * 80.0) % MediaQuery.of(context).size.height,
            child: Opacity(
              opacity: 0.1 * fadeAnimation.value,
              child: Container(
                width: 4 + (index % 3) * 2,
                height: 4 + (index % 3) * 2,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A7BFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }),
  );
}

Widget futuristicAppBar(BuildContext context, String title, Icon icon,
    Animation<double> fadeAnimation, AnimationController fadeController,
    {Widget trailing = const SizedBox(), bool showBackButtonInstead = false}) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0xFF3A7BFF).withValues(alpha: 0.1),
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      border: Border(
        bottom: BorderSide(
          color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
    ),
    child: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: FadeTransition(
        opacity: fadeAnimation,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3A7BFF).withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: showBackButtonInstead
                  ? IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : icon,
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF3A7BFF), Color(0xFF00D4AA)],
              ).createShader(bounds),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            FadeTransition(
              opacity: fadeAnimation,
              child: trailing,
            ),
          ],
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF3A7BFF)),
    ),
  );
}
