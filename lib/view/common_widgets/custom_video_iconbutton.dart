import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CommonVideoIconButton extends StatelessWidget {
  const CommonVideoIconButton({
    super.key, required this.icon, required this.onTap, this.padding,
  });

  final IconData icon;
  final Function() onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
     onTap:onTap,
      child: Padding(
        padding:padding?? const EdgeInsets.all(8.0),
        child: Icon(icon,
        color: AppColor.contentForeGroundColor,),
      ),
    );
  }
}