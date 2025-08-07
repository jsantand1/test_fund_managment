import 'package:flutter/material.dart';

/// A base state class that provides safe setState functionality
/// to avoid calling setState after dispose
mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  /// Safely calls setState if the widget is still mounted
  void safeSetState(VoidCallback fn) {
    if (_isMounted) {
      if (mounted) {
        setState(fn);
      } else {
        _isMounted = false;
      }
    }
  }

  /// Safely executes a callback if the widget is still mounted
  void ifMounted(VoidCallback fn) {
    if (_isMounted && mounted) {
      fn();
    } else {
      _isMounted = false;
    }
  }

  /// Safely executes a future and calls setState if the widget is still mounted
  Future<T?> safeAsync<T>(
    Future<T> future, {
    Function(T)? onSuccess,
    Function(dynamic)? onError,
    VoidCallback? onFinally,
  }) async {
    try {
      final result = await future;
      if (_isMounted && mounted) {
        setState(() {
          onSuccess?.call(result);
        });
      }
      return result;
    } catch (e) {
      if (_isMounted && mounted) {
        setState(() {
          onError?.call(e);
        });
      }
      return null;
    } finally {
      if (_isMounted && mounted) {
        onFinally?.call();
      }
    }
  }
}
