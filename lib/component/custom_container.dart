
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {

  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final BoxConstraints? constraints;
  final EdgeInsets? padding;
  final BorderRadius? radius;
  final Color? backgroundColor;
  final BoxBorder? border;

  const CustomContainer({super.key, this.width, this.height, this.margin, this.radius, this.child, this.padding, this.constraints, this.backgroundColor, this.border});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: width,
      height: height,
      margin: margin,
      constraints: constraints,
      decoration: BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(8),
          color: backgroundColor ?? Colors.white,
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(10, 10),
              blurRadius: 30,
            )
          ]
      ),
      child: child,
    );
  }
}