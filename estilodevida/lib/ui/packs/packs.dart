import 'package:cloud_firestore/cloud_firestore.dart';
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

                      final packOptions = packDocs.map((doc) {
                        return PackOption(
                          id: doc.id,
                          title: doc['title'],
                          lessons: doc['lessons'].toInt(),
                          unitPrice: doc['unitPrice'].toDouble(),
                          dueDays: doc['dueDays'],
                        );
                      }).toList();

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
                const SizedBox(height: 20),
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
    Key? key,
    required this.pack,
    required this.uid,
  }) : super(key: key);

  final PackOption pack;
  final String uid;

  @override
  _PackCardState createState() => _PackCardState();
}

class _PackCardState extends State<PackCard>
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
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10.0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: Image.asset(
                  'assets/images/logo_edv.png',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${widget.pack.lessons} Clases',
                style: GoogleFonts.roboto(
                  fontSize: 42,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${widget.pack.unitPrice.toStringAsFixed(3)}',
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              // Añadimos la cantidad de días disponibles
              Text(
                '${widget.pack.dueDays} días disponibles',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              BuyButton(pack: widget.pack, uid: widget.uid),
            ],
          ),
        ),
      ),
    );
  }
}
