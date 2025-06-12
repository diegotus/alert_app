import 'package:alert_app/app/core/utils/formater.dart';
import 'package:alert_app/app/core/utils/validators.dart';
import 'package:alert_app/app/data/models/site_model.dart';
import 'package:flutter/material.dart';
import 'package:alert_app/app/core/utils/storage_box.dart';

import 'package:get/get.dart';

import '../../../global_widgets/future_dropdown.dart' show FutureDropdownForm;
import '../controllers/registration_controller.dart';

const separator = SizedBox(height: 20);

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                spacing: 15,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/app_splash.png", height: 120),
                  Text(
                    'Enregistrement',
                    style: Get.textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),

                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Nom Complet'),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => controller.name = value ?? '',
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? 'Veuillez entrer votre Nom Complet svp.'
                                : null,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Numéro de Téléphone',
                      prefix: Text("+(509) "),
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [phoneFormatter],
                    textInputAction: TextInputAction.next,
                    onSaved:
                        (value) =>
                            controller.phone =
                                '+509${value ?? ''.replaceAll(RegExp(r"-"), '')}',
                    validator: validateHaitianPhoneNumber,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),

                  FutureDropdownForm(
                    future: controller.callListApi,
                    onSaved: (value) => controller.site = value?.name ?? '',
                    onChanged: (item) {},
                    onData: (data) {
                      if (data != null && data.isNotEmpty) {
                        StorageBox.sites.val =
                            data.map((el) => el.toJson()).toList();
                      }
                    },
                    initialValues:
                        () =>
                            StorageBox.sites.val
                                .map((el) => SiteModel.fromJson(el))
                                .toList(),
                    validator:
                        (value) =>
                            value == null
                                ? 'Veuillez Choisir un Site SVP.'
                                : null,
                    itemBuilder: (item) {
                      return Text(item.name);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text("S'enregistrer"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (controller.formKey.currentState!.validate()) {
      controller.formKey.currentState!.save();
      Get.showOverlay(
        asyncFunction: controller.registerUser,
        loadingWidget: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
  }
}
