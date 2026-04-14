import 'package:flutter/cupertino.dart';

import '../../core/config/extensions/all_extensions.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(color: color).center();
  }
}
