// Importer les packages nécessaires pour l'interface Flutter et les opérations asynchrones
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_ompay_flutter/view/client_page.dart';
import 'package:app_ompay_flutter/widgets/grid_background.dart';
import 'package:app_ompay_flutter/service/auth_manager.dart';

// Widget principal de la page de connexion, stateful pour gérer le contenu dynamique
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Classe d'état pour LoginPage, gère l'état et le cycle de vie
class _LoginPageState extends State<LoginPage> {
  // Contrôleur pour le carrousel d'images
  final PageController _pageController = PageController();
  // Contrôleur pour la saisie du numéro de téléphone
  final TextEditingController _phoneController = TextEditingController();
  // Contrôleur pour la saisie du mot de passe
  final TextEditingController _passwordController = TextEditingController();
  // Timer pour avancer automatiquement le carrousel
  Timer? _timer;
  // Index de la page actuelle pour le clipach
  int _currentPage = 0;
  // Code pays sélectionné pour la saisie du téléphone
  String selectedCountryCode = '+221';
  // Indicateur de chargement
  bool _isLoading = false;
  // Gestionnaire d'authentification
  late AuthManager _authManager;

  // Initialiser l'état, démarrer le timer du carrousel
  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  // Nettoyer les ressources lorsque le widget est supprimé
  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Gérer la connexion
  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneNumber = selectedCountryCode + _phoneController.text;
      final response = await _authManager.login(phoneNumber, _passwordController.text);

      if (response['success'] == true) {
        // Navigate to client page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ClientPage(authManager: _authManager),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Erreur de connexion'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Construire l'interface utilisateur pour la page de connexion
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar pour le carrousel
          SliverAppBar(
            expandedHeight: 250,
            pinned: false,
            backgroundColor: const Color(0xFF0A0A0A),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  const GridBackground(),
                  Column(
                    children: [
                      Container(
                        height: 200,
                        color: const Color(0xFF0A0A0A),
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: [
                            Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQy-2mKzunreZ3bHZUciD4cuqmyj7s7jHVSMA&s',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg1OjstnvrXRwwqk3d1Z6MVlyHxFHvKlmtmQ&s',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg1OjstnvrXRwwqk3d1Z6MVlyHxFHvKlmtmQ&s',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ],
                        ),
                      ),
                      ClipPath(
                        clipper: WavyClipper(),
                        child: Container(
                          height: 50,
                          color: const Color(0xFF1C1C1C),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? const Color(0xFFFF7900)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenu principal
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1C1C1C),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bienvenue sur OM Pay!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Connectez-vous à votre compte',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButton<String>(
                          value: selectedCountryCode,
                          items: const [
                            DropdownMenuItem(
                              value: '+221',
                              child: Text('🇸🇳 +221'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCountryCode = value!;
                            });
                          },
                          underline: const SizedBox(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            hintText: 'Numéro de téléphone',
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Mot de passe',
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7900),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Se connecter',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '© Orange Money tous les droits réservés by Teuw',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 40);

    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 40);

    path.quadraticBezierTo(size.width * 0.75, 80, size.width, 40);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
