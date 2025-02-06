import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/packs/widgets/buy_button.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PackOption {
  final String id;
  final String title;
  final int lessons;
  final double unitPrice;
  final int dueDays;

  PackOption({
    required this.id,
    required this.title,
    required this.lessons,
    required this.unitPrice,
    required this.dueDays,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lessons': lessons,
      'unitPrice': unitPrice,
      'dueDays': dueDays,
    };
  }
}

class PackSelectionScreen extends StatefulWidget {
  const PackSelectionScreen({super.key});

  @override
  State<PackSelectionScreen> createState() => _PackSelectionScreenState();
}

class _PackSelectionScreenState extends State<PackSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final user = context.watch<User?>();
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(title: 'Seleccionar Pack'),
      body: CommonBackgroundContainer(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('packs')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
                      }

                      final packDocs = snapshot.data?.docs ?? [];
                      if (packDocs.isEmpty) {
                        return Center(
                          child: Text(
                            'No hay Paquetes',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        );
                      }

                      List<PackOption> packOptions = packDocs.map((doc) {
                        return PackOption(
                          id: doc.id,
                          title: doc['title'],
                          lessons: doc['lessons'].toInt(),
                          unitPrice: doc['unitPrice'].toDouble(),
                          dueDays: doc['dueDays'],
                        );
                      }).toList();

                      packOptions
                          .sort((a, b) => b.lessons.compareTo(a.lessons));

                      return PageView.builder(
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: packOptions.length,
                        itemBuilder: (context, index) {
                          final pack = packOptions[index];
                          return PackCard(
                            pack: pack,
                            uid: user.uid,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PackCard extends StatefulWidget {
  const PackCard({
    super.key,
    required this.pack,
    required this.uid,
  });

  final PackOption pack;
  final String uid;

  @override
  PackCardState createState() => PackCardState();
}

class PackCardState extends State<PackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar el AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                const Color(0xFFD4E2FF).withOpacity(0.7), // un azul claro
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo_edv.png',
                                width: 200,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.pack.title,
                          style: GoogleFonts.roboto(
                            fontSize: 32,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '\$${widget.pack.unitPrice.toStringAsFixed(1)}',
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              color: Colors.purple.shade800,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.pack.dueDays} días disponibles',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BuyButtonPack(
                  pack: widget.pack,
                  uid: widget.uid,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
