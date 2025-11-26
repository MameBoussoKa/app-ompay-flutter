import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_ompay_flutter/service/auth_manager.dart';
import 'package:app_ompay_flutter/view/login_page.dart';

class ClientPage extends StatefulWidget {
  final AuthManager authManager;

  const ClientPage({super.key, required this.authManager});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isPayerSelected = true;
  bool _isSoldeVisible = false;
  bool _isDarkMode = true;
  bool _isScannerEnabled = true;
  String _selectedLanguage = 'Français';
  bool _isLoading = false;

  // Données utilisateur
  Map<String, dynamic>? _userData;
  List<dynamic> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _numeroController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await widget.authManager.getMe();
      if (response['success'] == true) {
        setState(() {
          _userData = response['data'];
          _transactions = _userData?['transactions'] ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Erreur de chargement des données'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[100],
      drawer: _buildDrawer(),
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // AppBar avec header
          SliverAppBar(
            expandedHeight: 200, // Augmenté pour la section solde
            pinned: true,
            backgroundColor: _isDarkMode
                ? const Color(0xFF1C1C1C)
                : Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Bonjour ',
                                      style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _userData != null
                                          ? '${_userData!['user']['prenom']} ${_userData!['user']['nom']}'
                                          : 'Utilisateur',
                                      style: const TextStyle(
                                        color: Color(0xFFFF7900),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    _isSoldeVisible
                                        ? (_userData?['compte']?['solde']?.toString() ?? '0')
                                        : '*******',
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? const Color(0xFFFF7900)
                                          : Colors.orange[700],
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: _isSoldeVisible ? 0 : 2,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _userData?['compte']?['devise'] ?? 'FCFA',
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isSoldeVisible = !_isSoldeVisible;
                                      });
                                    },
                                    child: Icon(
                                      _isSoldeVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // QR Code bien aligné
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Image.network(
                            'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=OM_PAY_MAME_BOUSSO',
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: Colors.white,
                                child: const Icon(Icons.qr_code, size: 60),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Contenu principal
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section principale avec onglets
                Container(
                  margin: const EdgeInsets.all(8), // Réduit de 16 à 8
                  decoration: BoxDecoration(
                    color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: !_isDarkMode
                        ? [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      // Onglets Payer / Transférer
                      Padding(
                        padding: const EdgeInsets.all(8), // Réduit de 16 à 8
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPayerSelected = true;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: true,
                                      groupValue: _isPayerSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          _isPayerSelected = value!;
                                        });
                                      },
                                      activeColor: const Color(0xFFFF7900),
                                    ),
                                    Text(
                                      'Payer',
                                      style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontWeight: _isPayerSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPayerSelected = false;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio<bool>(
                                      value: false,
                                      groupValue: _isPayerSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          _isPayerSelected = value!;
                                        });
                                      },
                                      activeColor: const Color(0xFFFF7900),
                                    ),
                                    Text(
                                      'Transférer',
                                      style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16,
                                        fontWeight: !_isPayerSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF7900),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.currency_exchange,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Champs de saisie et image scanner
                      Padding(
                        padding: const EdgeInsets.all(8), // Réduit de 16 à 8
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Champs de formulaire
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: _numeroController,
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: _isPayerSelected
                                          ? 'Saisir le numéro/code marchand'
                                          : 'Saisir le numéro',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: _isDarkMode
                                          ? const Color(0xFF2A2A2A)
                                          : Colors.grey[100],
                                      suffixIcon: Icon(
                                        Icons.person_outline,
                                        color: const Color(0xFFFF7900),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _montantController,
                                    style: TextStyle(
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Saisir le montant',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: _isDarkMode
                                          ? const Color(0xFF2A2A2A)
                                          : Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Image scanner à droite
                            GestureDetector(
                              onTap: () {
                                // Logique de scan
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Scanner activé'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                width: 100,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[300],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner,
                                      size: 40,
                                      color: Colors.grey[700],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Cliquer et\nscanner',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bouton Valider
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8), // Réduit
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_numeroController.text.isEmpty ||
                                  _montantController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Veuillez remplir tous les champs',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final montant = double.tryParse(_montantController.text);
                              if (montant == null || montant <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Montant invalide'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              if (_userData?['compte'] == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Aucun compte associé'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final compteId = _userData!['compte']['id'];
                                Map<String, dynamic> data = {'montant': montant};

                                if (_isPayerSelected) {
                                  // Payment - check if it's a phone number or merchant code
                                  if (RegExp(r'^\d+$').hasMatch(_numeroController.text)) {
                                    // Phone number
                                    data['recipient_telephone'] = _numeroController.text;
                                  } else {
                                    // Merchant code
                                    data['marchand_code'] = _numeroController.text;
                                  }
                                  await widget.authManager.pay(compteId, data);
                                } else {
                                  // Transfer
                                  data['destinataire_telephone'] = _numeroController.text;
                                  await widget.authManager.transfer(compteId, data);
                                }

                                // Refresh user data
                                await _loadUserData();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _isPayerSelected
                                          ? 'Paiement effectué avec succès!'
                                          : 'Transfert effectué avec succès!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // Clear fields
                                _numeroController.clear();
                                _montantController.clear();
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
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7900),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Valider',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Section Max it
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8), // Réduit de 16 à 8
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pour toute autre opération',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF2A2A2A)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7900),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Max it',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(
                            'Accéder à Max it',
                            style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: _isDarkMode ? Colors.white : Colors.black,
                            size: 16,
                          ),
                          onTap: () {
                            // Naviguer vers Max it
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12), // Réduit de 24 à 12

                // Section Historique
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8), // Réduit de 16 à 8
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historique',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.refresh,
                          color: Color(0xFFFF7900),
                        ),
                        onPressed: () {
                          setState(() {
                            // Rafraîchir l'historique
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Liste des transactions
                _transactions.isEmpty
                    ? _buildEmptyHistory()
                    : Container(
                        height: 160, // Réduit pour équilibrer
                        child: _buildTransactionsList(),
                      ),

                const SizedBox(height: 10), // Réduit de 20 à 10
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      height: 160, // Même hauteur que la liste
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.cloud_outlined, size: 60, color: Colors.grey),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7900),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 10,
                child: Icon(Icons.search, size: 30, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Vous n'avez pas encore de transaction Orange Money.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        final type = transaction['type'];
        String typeDisplay = '';
        IconData icon = Icons.swap_horiz;
        bool isPositive = false;

        switch (type) {
          case 'payment':
            typeDisplay = 'Paiement';
            icon = Icons.payment;
            isPositive = false;
            break;
          case 'transfer':
            typeDisplay = 'Transfert';
            icon = Icons.send;
            isPositive = false;
            break;
          case 'incoming_payment':
            typeDisplay = 'Paiement Reçu';
            icon = Icons.call_received;
            isPositive = true;
            break;
          case 'incoming_transfer':
            typeDisplay = 'Transfert Reçu';
            icon = Icons.call_received;
            isPositive = true;
            break;
          case 'deposit':
            typeDisplay = 'Dépôt';
            icon = Icons.add_circle;
            isPositive = true;
            break;
          default:
            typeDisplay = type;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: !_isDarkMode
                ? [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            title: Text(
              typeDisplay,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              transaction['reference'] ?? 'Ref: ${transaction['id']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isPositive ? '+' : '-'}${transaction['montant']} ${transaction['devise']}',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction['date'] ?? transaction['created_at'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _isDarkMode ? const Color(0xFF1C1C1C) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF0A0A0A) : Colors.grey[200],
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _isDarkMode
                              ? const Color(0xFF1C1C1C)
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(
                          'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=OM_PAY_${_userData?['user']['prenom']}_${_userData?['user']['nom']}',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _userData != null
                      ? '${_userData!['user']['prenom']} ${_userData!['user']['nom']}'
                      : 'Utilisateur',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userData?['telephone'] ?? 'Numéro inconnu',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(
              'Sombre',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
            },
            secondary: const Icon(Icons.brightness_6, color: Color(0xFFFF7900)),
            activeColor: const Color(0xFFFF7900),
          ),
          SwitchListTile(
            title: Text(
              'Scanner',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            value: _isScannerEnabled,
            onChanged: (value) {
              setState(() {
                _isScannerEnabled = value;
              });
            },
            secondary: const Icon(
              Icons.qr_code_scanner,
              color: Color(0xFFFF7900),
            ),
            activeColor: const Color(0xFFFF7900),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFFF7900)),
            title: Text(
              _selectedLanguage,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            onTap: () {
              // Changer la langue
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.power_settings_new,
              color: Color(0xFFFF7900),
            ),
            title: Text(
              'Se déconnecter',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () async {
              try {
                await widget.authManager.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur de déconnexion: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'OMPAY Version - 1.1.0(35)',
              textAlign: TextAlign.center,
              style: TextStyle(color: const Color(0xFFFF7900), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
