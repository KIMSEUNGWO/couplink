
import 'package:couplink_app/component/FontTheme.dart';
import 'package:couplink_app/component/svg_icon.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {

  final double height;
  final List<BottomIcon> children;
  final EdgeInsets? padding;

  const CustomBottomBar({super.key, required this.height, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      height: height + paddingBottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        left: padding?.left ?? 0,
        right: padding?.right ?? 0,
        top: padding?.top ?? 0,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(6), offset: const Offset(0, -6), blurRadius: 12)
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      )
    );
  }
}

class BottomIcon extends StatelessWidget {

  final SIcon sIcon;
  final String title;
  final GestureTapCallback callback;
  final bool isPressed;

  const BottomIcon({super.key, required this.sIcon, required this.title, required this.callback, required this.isPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            SvgIcon.asset(
                sIcon: sIcon,
                style: isPressed
                    ? SvgIconStyle(color: Theme.of(context).colorScheme.onPrimary,)
                    : null
            ),
            Text(title,
              style: FontTheme.of(context,
                size: FontSize.bodySmall,
                weight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}