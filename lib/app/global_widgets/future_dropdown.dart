import 'package:flutter/material.dart';

class FutureDropdownForm<T> extends StatefulWidget {
  const FutureDropdownForm({
    super.key,
    this.onChanged,
    required this.future,
    required this.itemBuilder,
    this.initialValue,
    this.onSaved,
    this.validator,
  });
  final void Function(T? item)? onChanged;
  final String? Function(T?)? validator;
  final void Function(T?)? onSaved;
  final Future<List<T>>? Function() future;
  final Widget Function(T item) itemBuilder;
  final T? initialValue;
  @override
  State<FutureDropdownForm<T>> createState() => _FutureDropdownFormState<T>();
}

class _FutureDropdownFormState<T> extends State<FutureDropdownForm<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: widget.future(),
      builder: (context, snapshot) {
        List<DropdownMenuItem<T>>? items;
        Widget? icon;
        String hintText = "Choose a Site";
        if (snapshot.connectionState == ConnectionState.waiting) {
          icon = FittedBox(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          hintText = "Click to Refresh";
          icon = Icon(Icons.refresh);
        }
        if (snapshot.hasData) {
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
        Widget dropdown = DropdownButtonFormField<T>(
          hint: Text(hintText),
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
