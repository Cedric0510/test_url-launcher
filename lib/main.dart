import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp, Email & SMS Launcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WhatsAppEmailSmsLauncher(),
    );
  }
}

class WhatsAppEmailSmsLauncher extends StatefulWidget {
  const WhatsAppEmailSmsLauncher({super.key});

  @override
  _WhatsAppEmailSmsLauncherState createState() =>
      _WhatsAppEmailSmsLauncherState();
}

class _WhatsAppEmailSmsLauncherState extends State<WhatsAppEmailSmsLauncher> {
  final String phoneNumber =
      '+33603283927'; // Numéro de téléphone pour WhatsApp et SMS
  final String email = 'jaysonmansuy@icloud.com'; // Adresse e-mail

  bool _isPhone = false; // Variable pour savoir si l'appareil est un téléphone

  @override
  void initState() {
    super.initState();
    _checkIfPhone();
  }

  // Vérification si l'appareil est un téléphone Android
  void _checkIfPhone() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.isPhysicalDevice) {
      setState(() {
        _isPhone = true;
      });
    }
  }

  // Fonction pour lancer WhatsApp
  void _launchWhatsApp() async {
    final String whatsappUrl = "https://wa.me/$phoneNumber";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  // Fonction pour lancer l'email
  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=Contact&body=Bonjour,', // Vous pouvez personnaliser le sujet et le corps
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  // Fonction pour envoyer un SMS
  void _launchSMS() async {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      query: 'body=Bonjour,', // Corps du message
    );

    if (await canLaunch(smsLaunchUri.toString())) {
      await launch(smsLaunchUri.toString());
    } else {
      throw 'Could not launch $smsLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lancer WhatsApp, Email et SMS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _launchWhatsApp,
              child: const Text('Contactez via WhatsApp'),
            ),
            const SizedBox(height: 20), // Espace entre les boutons
            ElevatedButton(
              onPressed: _launchEmail,
              child: const Text('Envoyer un e-mail'),
            ),
            const SizedBox(height: 20), // Espace entre les boutons
            // Si l'appareil est un smartphone, afficher le bouton SMS
            if (_isPhone)
              ElevatedButton(
                onPressed: _launchSMS,
                child: const Text('Envoyer un SMS'),
              ),
          ],
        ),
      ),
    );
  }
}
