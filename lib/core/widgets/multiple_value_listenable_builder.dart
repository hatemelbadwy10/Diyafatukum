import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MultipleValueListenableBuilder extends StatefulWidget {
  final List<ValueListenable> valueListenables;
  final Widget Function(BuildContext context, List<dynamic> values) builder;

  const MultipleValueListenableBuilder({
    super.key,
    required this.valueListenables,
    required this.builder,
  });

  @override
  State<MultipleValueListenableBuilder> createState() => _MultipleValueListenableBuilderState();
}

class _MultipleValueListenableBuilderState extends State<MultipleValueListenableBuilder> {
  late List<dynamic> values;

  @override
  void initState() {
    super.initState();
    values = widget.valueListenables.map((listen) => listen.value).toList();
    for (var i = 0; i < widget.valueListenables.length; i++) {
      widget.valueListenables[i].addListener(() {
        setState(() {
          values[i] = widget.valueListenables[i].value;
        });
      });
    }
  }

  @override
  void dispose() {
    for (var listenable in widget.valueListenables) {
      listenable.removeListener(() => setState(() {}));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, values);
  }
}
