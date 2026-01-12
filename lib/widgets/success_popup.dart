import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessPopup {
  static Future<void> show({
    required BuildContext context,
    String title = "Success!",
    String message = "",
    String animationPath = "assets/animations/success.json",
    Duration duration = const Duration(seconds: 2),
  }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Success Popup",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, _, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: _SuccessPopupWidget(
              title: title,
              message: message,
              animationPath: animationPath,
            ),
          ),
        );
      },
    );

    await Future.delayed(duration);

    if (!context.mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}

class _SuccessPopupWidget extends StatelessWidget {
  final String title;
  final String message;
  final String animationPath;

  const _SuccessPopupWidget({
    required this.title,
    required this.message,
    required this.animationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(animationPath, width: 120, height: 120),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (message.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
