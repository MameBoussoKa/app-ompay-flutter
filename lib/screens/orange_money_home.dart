import 'package:flutter/material.dart';

class OrangeMoneyHome extends StatefulWidget {
  const OrangeMoneyHome({Key? key}) : super(key: key);

  @override
  State<OrangeMoneyHome> createState() => _OrangeMoneyHomeState();
}

class _OrangeMoneyHomeState extends State<OrangeMoneyHome> {
  bool _showBalance = false;
  int _selectedTab = 0; // 0 = Payer, 1 = Transférer

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF0D0D0D);
    final headerColor = const Color(0xFF2A2A2A);
    final panelColor = const Color(0xFF1F1F1F);
    const orange = Color(0xFFFF7A00);

    // MediaQuery available via context when needed

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Hamburger
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu, color: Colors.white),
                    ),

                    const SizedBox(width: 6),

                    // Center content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Bonjour',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Mame ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Diarra',
                                style: TextStyle(
                                  color: orange,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Balance row
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _showBalance ? '125 600 FCFA' : '****** FCFA',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () => setState(() => _showBalance = !_showBalance),
                                child: Icon(
                                  _showBalance ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white54,
                                  size: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    // QR square
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.qr_code, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Payment / Transfer panel with colorful waves at right
              LayoutBuilder(builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 120, 16),
                      decoration: BoxDecoration(
                        color: panelColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tabs
                          Row(
                            children: [
                              _buildTab('Payer', 0),
                              const SizedBox(width: 8),
                              _buildTab('Transférer', 1),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Fields and right image
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildInput(
                                      controller: _numberController,
                                      hint: 'Saisir numéro / code marchand',
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInput(
                                      controller: _amountController,
                                      hint: 'Saisir le montant',
                                      keyboardType: TextInputType.number,
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: const Text(
                                          'Valider',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Right column with phone + QR
                              Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.phone_android, color: Colors.white54),
                                        SizedBox(height: 6),
                                        Text(
                                          'Cliquer\net scanner',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white60, fontSize: 11),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Colorful vertical bands painter positioned at right side of the panel
                    Positioned(
                      right: 10,
                      top: 6,
                      bottom: 6,
                      width: 120,
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: ColorfulWavePainter(),
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 18),

              // Max it section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A00),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Max',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Accéder à Max it",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chevron_right, color: Colors.white54),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Historique
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: panelColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Historique',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Column(
                        children: const [
                          Icon(Icons.history, color: Colors.white24, size: 54),
                          SizedBox(height: 12),
                          Text(
                            "Vous n'avez pas encore de transaction Orange Money.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final active = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? Colors.transparent : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}

// CustomPainter provided by user — kept identical to requested code
class ColorfulWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final colors = [
      const Color(0xFF60A5FA),
      const Color(0xFFA78BFA),
      const Color(0xFFF472B6),
      const Color(0xFFFB923C),
      const Color(0xFFFBBF24),
    ];

    final baseX = size.width * 0.4;
    final spacing = 8.0;
    final topTilt = 26.0;

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      final path = Path();

      final x = baseX + i * spacing;

      path.moveTo(x, size.height + 20);

      path.quadraticBezierTo(
        x,
        size.height * 0.2,
        x + topTilt * 0.1,
        size.height * 0.25,
      );

      path.quadraticBezierTo(
        x + topTilt * 0.1,
        size.height * 0.1,
        x + topTilt,
        -20,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
