import 'package:evo_project/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class CartProductWidget extends StatelessWidget {
  const CartProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenSize.width - 20,
      height: 100.h(context),
      child: Row(
        children: [
          Container(
            width: 100.w(context),
            height: 100.h(context),
            decoration: BoxDecoration(
              color: const Color(0xffF6F8FB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: BoxBorder.symmetric(
                  horizontal: BorderSide(color: Color(0xffDBE9F5), width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Small leather backpack',
                          style: context.textStyles.bodyMedium,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '\$ 167.5',
                          style: context.textStyles.bodyMedium!.copyWith(
                            color: context.colors.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Color: Blue',
                          style: context.textStyles.bodySmall,
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.add),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text('1', style: context.textStyles.bodySmall),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(Icons.remove),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
