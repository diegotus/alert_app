import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef Condition<T> = List<T> Function();

// ignore: must_be_immutable
class FutureDropdownForm<T> extends GetWidget {
  FutureDropdownForm({
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
  late final Rx<Future<List<T>>?> futureData;
  bool isRefreshing = false;
  void refreshFuture() {
    if (!isRefreshing) {
      isRefreshing = true;
      futureData.value = future();
    }
  }

  @override
  Widget build(Object context) {
    futureData = future().obs;
    List<T>? initValues;
    if (initialValues is Condition<T>) {
      initValues = (initialValues as Condition<T>)();
    } else {
      initValues = initialValues as List<T>?;
    }
    return Obx(() {
      return FutureBuilder<List<T>>(
        future: futureData.value,
        initialData: initValues,
        builder: (context, snapshot) {
          List<DropdownMenuItem<T>>? items;
          Widget? icon;
          String hintText = "Choisissez un Site";
          Widget? hintTextWidget;
          if (snapshot.connectionState == ConnectionState.waiting) {
            icon = FittedBox(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            hintText = "Cliquez pour Rafraichir";
            icon = Icon(Icons.refresh);
            isRefreshing = false;
          } else {
            isRefreshing = false;
          }
          if (snapshot.hasData) {
            onData?.call(snapshot.data);
            items =
                snapshot.data
                    ?.map(
                      (el) =>
                          DropdownMenuItem(value: el, child: itemBuilder(el)),
                    )
                    .toList();
          } else {
            hintText = "Cliquez pour Rafraichir";
          }
          if (initialValue != null) {
            hintTextWidget = itemBuilder(initialValue as T);
          } else {
            hintTextWidget = Text(hintText);
          }
          Widget dropdown = DropdownButtonFormField<T>(
            hint: hintTextWidget,
            items: items,
            value: initialValue,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            icon: icon,
          );

          return hintText == "Cliquez pour Rafraichir"
              ? InkWell(
                onTap: () {
                  refreshFuture();
                },
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: dropdown,
              )
              : dropdown;
        },
      );
    });
  }
}
