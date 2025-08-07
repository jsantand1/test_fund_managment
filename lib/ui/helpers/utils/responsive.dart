import 'package:flutter/material.dart';

/// Responsive breakpoints following Material Design guidelines
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1600;
}

/// Responsive helper class with utility methods
class Responsive {
  /// Check if screen is mobile size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Breakpoints.mobile;
  }

  /// Check if screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.mobile && width < Breakpoints.desktop;
  }

  /// Check if screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.desktop;
  }

  /// Check if screen is large desktop size
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Breakpoints.largeDesktop;
  }

  /// Get responsive value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop;
    }
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Get sidebar width based on screen size
  static double getSidebarWidth(BuildContext context, {bool isExpanded = true}) {
    if (isMobile(context)) {
      return isExpanded ? MediaQuery.of(context).size.width * 0.8 : 0;
    }
    
    return value(
      context,
      mobile: isExpanded ? 280 : 0,
      tablet: isExpanded ? 260 : 70,
      desktop: isExpanded ? 280 : 80,
      largeDesktop: isExpanded ? 320 : 80,
    );
  }

  /// Get content padding based on screen size
  static EdgeInsets getContentPadding(BuildContext context) {
    return value(
      context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(20),
      desktop: const EdgeInsets.all(24),
      largeDesktop: const EdgeInsets.all(32),
    );
  }

  /// Get grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    return value(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      largeDesktop: 4,
    );
  }

  /// Get max content width for large screens
  static double getMaxContentWidth(BuildContext context) {
    return value(
      context,
      mobile: double.infinity,
      tablet: double.infinity,
      desktop: 1200,
      largeDesktop: 1400,
    );
  }
}

/// Widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isLargeDesktop(context) && largeDesktop != null) {
      return largeDesktop!;
    }
    if (Responsive.isDesktop(context) && desktop != null) {
      return desktop!;
    }
    if (Responsive.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Responsive padding widget
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;
  final EdgeInsets? largeDesktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.value(
      context,
      mobile: mobile ?? const EdgeInsets.all(16),
      tablet: tablet ?? const EdgeInsets.all(20),
      desktop: desktop ?? const EdgeInsets.all(24),
      largeDesktop: largeDesktop ?? const EdgeInsets.all(32),
    );

    return Padding(
      padding: padding,
      child: child,
    );
  }
}
