import 'package:flutter/material.dart';

class AppModal {
  /// Muestra un modal de confirmación personalizable
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    Widget? icon,
    Widget? content,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmButtonColor,
    Color? cancelButtonColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: content ?? Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              onCancel?.call();
            },
            child: Text(
              cancelText,
              style: TextStyle(
                color: cancelButtonColor ?? Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmButtonColor ?? Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Muestra un modal de información simple
  static Future<void> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    Widget? icon,
    Widget? content,
    String buttonText = 'Cerrar',
    Color? buttonColor,
    VoidCallback? onClose,
    bool barrierDismissible = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: content ?? Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onClose?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Muestra un modal personalizado con contenido completamente customizable
  static Future<T?> showCustom<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    BorderRadius? borderRadius,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }



  /// Muestra un SnackBar de éxito
  static void showSuccessSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }

  /// Muestra un SnackBar de error
  static void showErrorSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onActionPressed,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed ?? () {},
              )
            : null,
      ),
    );
  }
}
