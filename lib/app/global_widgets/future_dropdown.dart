import 'package:flutter/material.dart';

typedef Condition<T> = List<T> Function();

class FutureDropdownForm<T> extends StatefulWidget {
  const FutureDropdownForm({
    super.key,
    this.onChanged,
    required this.future,
    required this.itemBuilder,
    this.initialValue,
    this.onSaved,
    this.validator,
    this.initialValues,
    this.onData,
  });
  final void Function(T? item)? onChanged;
  final void Function(List<T>? data)? onData;
  final String? Function(T?)? validator;
  final void Function(T?)? onSaved;
  final Future<List<T>>? Function() future;
  final dynamic initialValues;
  final Widget Function(T item) itemBuilder;
  final T? initialValue;
  @override
  State<FutureDropdownForm<T>> createState() => _FutureDropdownFormState<T>();
}

class _FutureDropdownFormState<T> extends State<FutureDropdownForm<T>> {
  List<T>? initialvalues;
  @override
  void initState() {
    super.initState();
    if (widget.initialValues is Condition<T>) {
      initialvalues = (widget.initialValues as Condition<T>)();
    } else {
      initialvalues = widget.initialValues as List<T>?;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: widget.future(),
      initialData: initialvalues,
      builder: (context, snapshot) {
        List<DropdownMenuItem<T>>? items;
        Widget? icon;
        String hintText = "Choose a Site";
        Widget? hintTextWidget;
        if (snapshot.connectionState == ConnectionState.waiting) {
          icon = FittedBox(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          hintText = "Click to Refresh";
          icon = Icon(Icons.refresh);
        }
        if (snapshot.hasData) {
          print("its ash data");
          widget.onData?.call(snapshot.data);
          items =
              snapshot.data
                  ?.map(
                    (el) => DropdownMenuItem(
                      value: el,
                      child: widget.itemBuilder(el),
                    ),
                  )
                  .toList();
        } else {
          hintText = "Click to Refresh";
        }
        if (widget.initialValue != null) {
          hintTextWidget = widget.itemBuilder(widget.initialValue as T);
        } else {
          hintTextWidget = Text(hintText);
        }
        Widget dropdown = DropdownButtonFormField<T>(
          hint: hintTextWidget,
          items: items,
          value: widget.initialValue,
          onChanged: widget.onChanged,
          onSaved: widget.onSaved,
          validator: widget.validator,
          icon: icon,
        );

        return hintText == "Click to Refresh"
            ? InkWell(
              onTap: () {
                setState(() {});
              },
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: dropdown,
            )
            : dropdown;
      },
    );
  }
}
