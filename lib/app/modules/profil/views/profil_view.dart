import 'package:alert_app/app/core/utils/storage_box.dart';
import 'package:alert_app/app/core/utils/validators.dart';
import 'package:alert_app/app/data/models/site_model.dart';
import 'package:alert_app/app/data/models/user_model.dart';
import 'package:alert_app/app/global_widgets/future_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/utils/formater.dart';
import '../controllers/profil_controller.dart';

class ProfilView extends GetView<ProfilController> {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context) {
    var phone = getPhoneFormatter("48758495");
    phoneFormatter.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(
        text: controller.user.value.phone.replaceAll("+509", ""),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Profil'), centerTitle: true),
      resizeToAvoidBottomInset: false,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder(
                id: "form_Widget",
                init: controller,
                builder: (_) {
                  return Form(
                    key: controller.formKey,
                    onChanged: () {},
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 15,
                        children: [
                          TextFormField(
                            initialValue: controller.user.value.name,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                            ),
                            textInputAction: TextInputAction.next,

                            onChanged: (value) {
                              controller.user.update((val) {
                                val?.name = value;
                              });
                            },
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Please enter your full name'
                                  : null;
                            },
                          ),

                          TextFormField(
                            initialValue: phoneFormatter.maskText(
                              controller.user.value.phone.replaceAll(
                                "+509",
                                '',
                              ),
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                            ),
                            textInputAction: TextInputAction.next,

                            keyboardType: TextInputType.phone,
                            inputFormatters: [phoneFormatter],

                            onChanged: (value) {
                              phone.clear();
                              controller.user.update((val) {
                                val?.phone = value.replaceAll(
                                  RegExp(r"\(|\)|\s|-"),
                                  '',
                                );
                              });
                            },
                            validator: validateHaitianPhoneNumber,
                          ),

                          FutureDropdownForm<SiteModel>(
                            initialValue:
                                controller.user.value.site.isNotEmpty
                                    ? SiteModel(
                                      name: controller.user.value.site,
                                    )
                                    : null,
                            future: controller.callListApi,
                            onData: (data) {
                              if (data != null && data.isNotEmpty) {
                                StorageBox.sites.val =
                                    data.map((el) => el.toJson()).toList();
                              }
                            },
                            initialValues: () {
                              return StorageBox.sites.val
                                  .map((el) => SiteModel.fromJson(el))
                                  .toList();
                            },
                            onChanged: (item) {
                              if (item != null) {
                                controller.user.update((val) {
                                  val?.site = item?.name ?? '';
                                });
                              }
                            },
                            validator:
                                (value) =>
                                    value == null
                                        ? 'Please enter your site name'
                                        : null,
                            itemBuilder: (item) {
                              return Text(item.name);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Obx(() {
              return Visibility(
                visible: controller.hasChanges(),
                child: Container(
                  padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(
                          context,
                        ).viewInsets.bottom, // Adjusts for keyboard height
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: controller.resetUser,
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.showOverlay(
                            asyncFunction: controller.updateUser,
                            loadingWidget: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget separator() {
    return SizedBox(height: 20);
  }
}
