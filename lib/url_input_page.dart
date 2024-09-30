import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UrlInputPage extends StatefulWidget {
  const UrlInputPage({super.key});

  @override
  _UrlInputPageState createState() => _UrlInputPageState();
}

class _UrlInputPageState extends State<UrlInputPage> {
  final List<TextEditingController> _urlControllers = List.generate(
    10,
    (index) => TextEditingController(),
  ); // Crée 10 champs de texte pour entrer les URLs

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Méthode pour envoyer les URLs
  Future<void> _sendUrls() async {
    if (_formKey.currentState!.validate()) {
      final List<String> urls = _urlControllers
          .where((controller) => controller.text.isNotEmpty)
          .map((controller) => controller.text)
          .toList();

      try {
        final response = await http.post(
          Uri.parse('https://example.com/submit-urls'),
          body: {'urls': urls.join(',')},
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URLs envoyées avec succès')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'envoi des URLs')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de connexion au serveur: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _urlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrer les URLs des annonces'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _urlControllers[index],
                        decoration: InputDecoration(
                          labelText: 'URL annonce ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            Uri? uri = Uri.tryParse(value);
                            if (uri == null || !uri.isAbsolute) {
                              return 'URL invalide';
                            }
                          }
                          return null;
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendUrls,
                child: const Text('Envoyer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
