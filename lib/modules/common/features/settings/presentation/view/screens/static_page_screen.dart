import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../data/model/static_page_enum.dart';
import '../../controller/static_page_cubit/static_page_cubit.dart';

class StaticPageScreen extends StatelessWidget {
  const StaticPageScreen({super.key, required this.type});

  final StaticPage type;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StaticPageCubit>()..getStaticPageContent(type),
      child: Scaffold(
        appBar: CustomAppBar.build(titleText: type.title,titleStyle: context.titleSmall.bold.s18,backgroundColor: context.scaffoldBackgroundColor,),
        body: BlocBuilder<StaticPageCubit, StaticPageState>(
          builder: (context, state) {
            return state.status.build(onSuccess: (content) => Column(children: [HtmlWidget(content)]).withListView());
          },
        ).withSafeArea(),
      ),
    );
  }
}
