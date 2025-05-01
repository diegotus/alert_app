import 'package:alert_app/app/core/utils/formater.dart';
import 'package:alert_app/app/core/utils/validators.dart';
import 'package:alert_app/app/data/models/site_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../global_widgets/future_dropdown.dart' show FutureDropdownForm;
import '../controllers/registration_controller.dart';

const separator = SizedBox(height: 20);

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              spacing: 15,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  onSaved: (value) => controller.name = value ?? '',
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Please enter your full name' : null,
                ),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [phoneFormatter],
                  onSaved:
                      (value) =>
                          controller.phone =
                              value?.replaceAll(RegExp(r"\(|\)|\s|-"), '') ??
                              '',
                  validator: validateHaitianPhoneNumber,
                ),

                FutureDropdownForm(
                  future: controller.callListApi,
                  onSaved: (value) => controller.site = value?.name ?? '',
                  onChanged: (item) {},
                  validator:
                      (value) =>
                          value == null ? 'Please enter your site name' : null,
                  itemBuilder: (item) {
                    return Text(item.name);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (controller.formKey.currentState!.validate()) {
      controller.formKey.currentState!.save();
      controller.registerUser();
    }
  }
}
