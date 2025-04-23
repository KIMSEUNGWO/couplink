import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {

  final SvgPicture svgPicture;

  const SvgIcon.privateConstructor(this.svgPicture, {super.key});

  static SvgIcon asset({required SIcon sIcon, SvgIconStyle? style,}) {
    return _SvgIconBuilder(sIcon: sIcon).build(style);
  }

  @override
  Widget build(BuildContext context) {
    return svgPicture;
  }

}

class SvgIconStyle {

  double? width;
  double? height;
  Color? color;
  BoxFit? fit;
  BlendMode? blendMode;

  SvgIconStyle({this.width, this.height, this.color, this.fit, this.blendMode});

}

class SIcon {

  final String picture;
  final double width;
  final double height;

  const SIcon({required this.picture, required this.width, required this.height});

  static const SIcon calendar = SIcon(picture: 'assets/icons/calendar.svg', width: 24, height: 24);
  static const SIcon checkCircle = SIcon(picture: 'assets/icons/check_circle.svg', width: 18, height: 18);
  static const SIcon connect = SIcon(picture: 'assets/icons/connect.svg', width: 24, height: 24);
  static const SIcon disconnect = SIcon(picture: 'assets/icons/disconnect.svg', width: 24, height: 24);
  static const SIcon female = SIcon(picture: 'assets/icons/female.svg', width: 16, height: 16);
  static const SIcon gear = SIcon(picture: 'assets/icons/gear.svg', width: 21, height: 21);
  static const SIcon headset = SIcon(picture: 'assets/icons/headset.svg', width: 18, height: 18);
  static const SIcon heart = SIcon(picture: 'assets/icons/heart.svg', width: 21, height: 21);
  static const SIcon logout = SIcon(picture: 'assets/icons/logout.svg', width: 18, height: 18);
  static const SIcon male = SIcon(picture: 'assets/icons/male.svg', width: 16, height: 16);
  static const SIcon nickname = SIcon(picture: 'assets/icons/nickname.svg', width: 24, height: 24);
  static const SIcon paste = SIcon(picture: 'assets/icons/paste.svg', width: 16, height: 16);
  static const SIcon trash = SIcon(picture: 'assets/icons/trash.svg', width: 24, height: 24);
  static const SIcon user = SIcon(picture: 'assets/icons/user.svg', width: 24, height: 24);
  static const SIcon userEdit = SIcon(picture: 'assets/icons/user-edit.svg', width: 18, height: 18);

  static const SIcon kakao = SIcon(picture: 'assets/icons/kakao.svg', width: 12, height: 12);

  static const SIcon p1 = SIcon(picture: 'assets/icons/profile/P1.svg', width: 100, height: 100);
  static const SIcon p2 = SIcon(picture: 'assets/icons/profile/P2.svg', width: 100, height: 100);
  static const SIcon p3 = SIcon(picture: 'assets/icons/profile/P3.svg', width: 100, height: 100);
  static const SIcon p4 = SIcon(picture: 'assets/icons/profile/P4.svg', width: 100, height: 100);
  static const SIcon p5 = SIcon(picture: 'assets/icons/profile/P5.svg', width: 100, height: 100);
  static const SIcon p6 = SIcon(picture: 'assets/icons/profile/P6.svg', width: 100, height: 100);
  static const SIcon p7 = SIcon(picture: 'assets/icons/profile/P7.svg', width: 100, height: 100);
  static const SIcon p8 = SIcon(picture: 'assets/icons/profile/P8.svg', width: 100, height: 100);
  static const SIcon p9 = SIcon(picture: 'assets/icons/profile/P9.svg', width: 100, height: 100);

}


class _SvgIconBuilder {

  final SIcon sIcon;

  _SvgIconBuilder({required this.sIcon});

  SvgIcon build(SvgIconStyle? style) {
    return SvgIcon.privateConstructor(SvgPicture.asset(sIcon.picture,
        width: style?.width ?? sIcon.width,
        height: style?.height ?? sIcon.height,
        fit: style?.fit ?? BoxFit.contain,
        colorFilter: style == null || style.color == null ? null : ColorFilter.mode(style.color!, style.blendMode ?? BlendMode.srcIn),
    ));
  }

}