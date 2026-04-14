// import 'package:flutter/material.dart';

// import '../../../../../../../core/config/extensions/all_extensions.dart';
// import '../../../../../../../core/resources/resources.dart';
// import '../../../data/model/login_type.dart';

// class SocialLoginButton extends StatelessWidget {
//   const SocialLoginButton({super.key, required this.type, this.onTap});
//   final LoginType type;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         type.icon.svg(),
//         8.gap,
//         Text(type.title, style: context.displayLarge.s16.regular),
//       ],
//     )
//         .paddingAll(12)
//         .onTap(() => onTap?.call(), borderRadius: AppSize.mainRadius.borderRadius)
//         .setContainerToView(
//           color: context.scaffoldBackgroundColor,
//           radius: AppSize.mainRadius,
//           borderColor: context.primaryDividerColor,
//         )
//         .visible(type.enabled);
//   }
// }
