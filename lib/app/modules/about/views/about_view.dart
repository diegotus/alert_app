// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class AboutView extends GetView {
  const AboutView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        centerTitle: true,
        foregroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: Colors.black),
                text:
                    "Restez en sécurité et informé grâce à l'application Haiti Alertes, votre compagnon indispensable pour recevoir les alertes d'urgence et les notifications importantes en Haïti. Notre application vous fournit des mises à jour en temps réel directement sur votre iPhone, vous garantissant ainsi l'accès aux informations dont vous avez besoin, au moment opportun.\n\n",
                children: [
                  TextSpan(
                    text: "Avec l'application Haiti Alertes, vous pouvez :\n\n",
                  ),
                  textSpanBullet([
                    NumberedSpanText(
                      title: "Recevoir des alertes d'urgence instantanées :",
                      text:
                          "Recevez des notifications push en temps réel pour les situations urgentes, les annonces de sécurité publique et autres mises à jour critiques.",
                    ),
                    NumberedSpanText(
                      title: " Prioriser les alertes critiques :",
                      text:
                          "Pour les alertes les plus cruciales, notre application est conçue pour capter votre attention. Ces notifications peuvent inclure des notifications plein écran accompagnées d'un son et d'une vibration distincts, garantissant ainsi que les informations essentielles ne soient pas manquées, même lorsque votre appareil est en mode silencieux (sous réserve des autorisations).",
                    ),
                    NumberedSpanText(
                      title: "Accuser réception :",
                      text:
                          "Confirmez rapidement que vous avez reçu et vu des alertes importantes, indiquant ainsi aux intervenants ou aux autorités que le message a été lu.",
                    ),
                    NumberedSpanText(
                      title: "Accéder à l'historique des notifications :",
                      text:
                          "Suivez toutes les alertes passées grâce à une liste facile à parcourir. Consultez les informations, instructions ou mises à jour importantes à tout moment.",
                    ),
                    NumberedSpanText(
                      title: "Alertes personnalisées (par inscription) :",
                      text:
                          "Enregistrez votre profil, en indiquant votre nom, votre numéro de téléphone et le lieu ou l'emplacement désigné. Cela vous permet de recevoir des alertes plus spécifiquement adaptées à votre région ou à votre organisation.",
                    ),
                    NumberedSpanText(
                      title: "Simple et fiable :",
                      text:
                          "Conçue pour une utilisation facile, elle permet à chacun d'accéder et de comprendre rapidement les informations essentielles.",
                    ),
                  ]),

                  TextSpan(
                    text:
                        "L'application Haiti Alertes est conçue pour améliorer votre sécurité et votre préparation en vous offrant un canal fiable et direct pour les communications cruciales. Qu'il s'agisse d'une alerte météo, d'une annonce de santé publique ou de toute autre situation urgente, notre objectif est de vous aider à rester informé et à prendre les précautions nécessaires.\n\n",
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Image.asset("assets/icons/branding_icon.png", height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.copyright, size: 20),
                Text(
                  "Tous Droits Reservés 2025",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

TextSpan textSpanBullet(List<NumberedSpanText> data) {
  return TextSpan(
    children:
        data.indexed.map((e) {
          var title = e.$2.title;
          if (title != null) {
            title += " ";
          }
          return TextSpan(
            children: [
              TextSpan(
                text: "${e.$1 + 1}) ${title ?? ""}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: "${e.$2.text}\n\n"),
            ],
          );
        }).toList(),
  );
}

class NumberedSpanText {
  String text;
  String? title;
  NumberedSpanText({required this.text, this.title});
}
