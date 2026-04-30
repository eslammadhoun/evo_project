import 'package:evo_project/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoButtom extends StatelessWidget {
  final String title;
  final String iconName;
  final bool hasLeading;
  final void Function()? onTap;
  const InfoButtom({
    super.key,
    required this.title,
    required this.iconName,
    required this.hasLeading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          width: context.screenSize.width - 20,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
            border: BoxBorder.fromLTRB(
              left: BorderSide(color: const Color(0xffDBE9F5), width: 1),
              top: BorderSide(color: const Color(0xffDBE9F5), width: 1),
              right: BorderSide.none,
              bottom: BorderSide(color: const Color(0xffDBE9F5), width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('lib/assets/icons/$iconName.svg'),
                  const SizedBox(width: 10),
                  Text(title, style: context.textStyles.bodyMedium),
                ],
              ),
              hasLeading
                  ? Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffF84C6B),
                      ),
                      child: Center(
                        child: Text('1', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
