import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import du package url_launcher
import 'url_input_page.dart'; // Import de la page UrlInputPage

void main() {
  runApp(const MyApp());
}

// MyApp est le widget racine de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _experiencePercentage =
      0; // Variable pour stocker le pourcentage d'expérience
  int _level = 1; // Variable pour stocker le niveau de l'utilisateur
  String _message = ''; // Variable pour stocker le message des paliers

  // Méthode appelée pour augmenter l'expérience
  void _increaseExperience() {
    setState(() {
      if (_experiencePercentage < 100) {
        _experiencePercentage += 10; // Incrémente l'expérience par 10%
        if (_experiencePercentage > 100) {
          _experiencePercentage = 100; // S'assurer que cela ne dépasse pas 100%
        }
      } else {
        _experiencePercentage = 0; // Réinitialise à 0 après avoir atteint 100%
        _level++; // Augmente le niveau de l'utilisateur
        _checkLevelMessage(); // Vérifie si un palier de niveau est atteint
      }
    });
  }

  // Méthode pour vérifier le niveau et définir un message spécial
  void _checkLevelMessage() {
    if (_level % 10 == 0) {
      if (_level == 10) {
        _message = 'Meilleur vendeur de la région';
      } else if (_level == 20) {
        _message = 'Meilleur vendeur de France';
      } else if (_level == 30) {
        _message = 'Meilleur vendeur du monde';
      } else if (_level == 40) {
        _message = 'MEILLEUR VENDEUR DE TOUS LES TEMPS DU PONEY FRINGANT!!!!';
      }
    } else {
      _message = ''; // Pas de message spécial si ce n'est pas un multiple de 10
    }
  }

  // Méthode pour lancer WhatsApp
  Future<void> _launchWhatsApp() async {
    const phone = '+123456789'; // Numéro de téléphone cible
    final Uri whatsappUri = Uri.parse('https://wa.me/$phone');
    if (!await launchUrl(whatsappUri)) {
      throw 'Could not launch $whatsappUri';
    }
  }

  // Méthode pour lancer un Email
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'example@example.com',
      query: 'subject=Bonjour&body=Ceci est un test',
    );
    if (!await launchUrl(emailUri)) {
      throw 'Could not launch $emailUri';
    }
  }

  // Méthode pour lancer un SMS
  Future<void> _launchSms() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: '+123456789',
    );
    if (!await launchUrl(smsUri)) {
      throw 'Could not launch $smsUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil Gamification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Compteur de niveau
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'NV: ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_level',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Barre d'expérience
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: LinearProgressIndicator(
                value: _experiencePercentage /
                    100, // Convertir le pourcentage en valeur comprise entre 0 et 1
                minHeight: 20.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Expérience: $_experiencePercentage%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _increaseExperience,
              child: const Text('Gagner de l\'expérience'),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _message,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _launchWhatsApp,
              child: const Text('Lancer WhatsApp'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchEmail,
              child: const Text('Envoyer un Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchSms,
              child: const Text('Envoyer un SMS'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UrlInputPage(),
                  ),
                );
              },
              child: const Text('Entrer des URLs d\'annonces'),
            ),
          ],
        ),
      ),
    );
  }
}
