import 'package:flutter/material.dart';

class SeniDendangView extends StatelessWidget {
  const SeniDendangView({super.key});

  static const Color primaryColor = Color(0xFF2F9C95);
  static const Color darkColor = Color(0xFF14213D);
  static const Color textSecondary = Color(0xFF7D8AA4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FCFC),

      // ============================================================
      // APP BAR
      // ============================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF7FCFC),
        surfaceTintColor: Colors.transparent,
        foregroundColor: darkColor,
        title: const Text(
          'Seni Dendang',
          style: TextStyle(fontWeight: FontWeight.w800, color: darkColor),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====================================================
              // HERO
              // ====================================================
              _buildHero(),

              const SizedBox(height: 26),

              // ====================================================
              // PENGENALAN
              // ====================================================
              _buildSectionTitle(
                icon: Icons.music_note_rounded,
                title: 'Apo Itu Seni Dendang?',
              ),

              const SizedBox(height: 12),

              _buildTextCard(
                child: const Text(
                  'Seni Dendang merupakan salah satu bentuk kesenian '
                  'vokal tradisional yang hidup dalam masyarakat '
                  'Suku Serawai, khususnya di wilayah Bengkulu Selatan. '
                  'Kesenian ini disampaikan melalui nyanyian dengan '
                  'irama tertentu sehingga menghasilkan lantunan yang '
                  'memiliki nilai seni, bahasa, dan budaya.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: Color(0xFF45516A),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // ====================================================
              // SERAWAI BENGKULU SELATAN
              // ====================================================
              _buildSectionTitle(
                icon: Icons.location_on_rounded,
                title: 'Serawai Bengkulu Selatan',
              ),

              const SizedBox(height: 12),

              _buildTextCard(
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Masyarakat Serawai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: darkColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Suku Serawai merupakan salah satu masyarakat '
                      'yang memiliki kekayaan bahasa dan kebudayaan '
                      'tradisional di Provinsi Bengkulu. Di Kabupaten '
                      'Bengkulu Selatan, bahasa Serawai masih digunakan '
                      'dalam kehidupan masyarakat dan menjadi bagian '
                      'penting dari identitas budaya daerah.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: Color(0xFF45516A),
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Seni Dendang menjadi salah satu cara masyarakat '
                      'mengekspresikan bahasa, perasaan, nasihat, cerita, '
                      'dan nilai kehidupan melalui bentuk nyanyian '
                      'tradisional.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: Color(0xFF45516A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ====================================================
              // KARAKTERISTIK
              // ====================================================
              _buildSectionTitle(
                icon: Icons.graphic_eq_rounded,
                title: 'Ciri Seni Dendang',
              ),

              const SizedBox(height: 12),

              _buildFeatureCard(
                icon: Icons.record_voice_over_rounded,
                iconBackground: const Color(0xFFE4F6F3),
                iconColor: primaryColor,
                title: 'Kesenian Vokal',
                description:
                    'Disampaikan melalui suara atau nyanyian sebagai '
                    'unsur utama pertunjukan.',
              ),

              const SizedBox(height: 10),

              _buildFeatureCard(
                icon: Icons.multitrack_audio_rounded,
                iconBackground: const Color(0xFFFFF1D6),
                iconColor: const Color(0xFFE9A62A),
                title: 'Memiliki Irama',
                description:
                    'Syair dilantunkan menggunakan pola irama tertentu '
                    'sehingga memiliki ciri khas dalam penyampaiannya.',
              ),

              const SizedBox(height: 10),

              _buildFeatureCard(
                icon: Icons.translate_rounded,
                iconBackground: const Color(0xFFEAF1FC),
                iconColor: const Color(0xFF5886C8),
                title: 'Bahasa Serawai',
                description:
                    'Bahasa daerah menjadi unsur penting dalam '
                    'penyampaian syair dan pesan budaya.',
              ),

              const SizedBox(height: 10),

              _buildFeatureCard(
                icon: Icons.people_alt_rounded,
                iconBackground: const Color(0xFFFFE8EC),
                iconColor: const Color(0xFFE66F87),
                title: 'Warisan Masyarakat',
                description:
                    'Dendang diwariskan sebagai bagian dari kebudayaan '
                    'dan identitas masyarakat Serawai.',
              ),

              const SizedBox(height: 26),

              // ====================================================
              // NILAI BUDAYA
              // ====================================================
              _buildSectionTitle(
                icon: Icons.favorite_rounded,
                title: 'Nilai Budaya',
              ),

              const SizedBox(height: 12),

              _buildCultureCard(),

              const SizedBox(height: 26),

              // ====================================================
              // PERAN DENDANG
              // ====================================================
              _buildSectionTitle(
                icon: Icons.auto_awesome_rounded,
                title: 'Peran Seni Dendang',
              ),

              const SizedBox(height: 12),

              _buildNumberItem(
                number: '01',
                title: 'Menjaga Bahasa Daerah',
                description:
                    'Membantu memperkenalkan dan mempertahankan '
                    'penggunaan bahasa Serawai.',
              ),

              _buildNumberItem(
                number: '02',
                title: 'Menyampaikan Pesan',
                description:
                    'Nyanyian dapat menjadi media penyampaian pesan, '
                    'nasihat, dan nilai kehidupan.',
              ),

              _buildNumberItem(
                number: '03',
                title: 'Memperkuat Identitas',
                description:
                    'Menjadi bagian dari identitas budaya masyarakat '
                    'Serawai Bengkulu Selatan.',
              ),

              _buildNumberItem(
                number: '04',
                title: 'Pelestarian Budaya',
                description:
                    'Pengenalan kepada generasi muda membantu menjaga '
                    'keberlanjutan kesenian tradisional.',
              ),

              const SizedBox(height: 26),

              // ====================================================
              // QUOTE
              // ====================================================
              _buildQuote(),

              const SizedBox(height: 28),

              // ====================================================
              // FOOTER
              // ====================================================
              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.music_note_rounded,
                      color: primaryColor,
                      size: 22,
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Seni Dendang • Serawai Bengkulu Selatan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HERO
  // ============================================================

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFE5F7F4), Color(0xFFECF9F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Budaya Serawai',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Seni\nDendang',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Warisan vokal tradisional masyarakat '
                  'Serawai Bengkulu Selatan.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF526078),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Container(
            width: 95,
            height: 95,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEDC9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.music_note_rounded,
              size: 52,
              color: Color(0xFFE7A32B),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE4F6F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 21, color: primaryColor),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: darkColor,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TEXT CARD
  // ============================================================

  Widget _buildTextCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EFF2)),
      ),
      child: child,
    );
  }

  // ============================================================
  // FEATURE CARD
  // ============================================================

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8EFF2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 24, color: iconColor),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: darkColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Color(0xFF657087),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CULTURE CARD
  // ============================================================

  Widget _buildCultureCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.diversity_3_rounded, color: Color(0xFFE9A62A)),
              SizedBox(width: 8),
              Text(
                'Lebih dari Sekadar Nyanyian',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Seni Dendang tidak hanya menjadi bentuk hiburan, '
            'tetapi juga memiliki nilai budaya. Melalui dendang, '
            'bahasa daerah, pesan kehidupan, kebersamaan, serta '
            'identitas masyarakat Serawai dapat terus dikenal '
            'dan diwariskan kepada generasi berikutnya.',
            style: TextStyle(
              fontSize: 13,
              height: 1.7,
              color: Color(0xFF56627A),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NUMBER ITEM
  // ============================================================

  Widget _buildNumberItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFE5F7F4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: darkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF657087),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUOTE
  // ============================================================

  Widget _buildQuote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F8F7),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Text(
            '“',
            style: TextStyle(
              fontSize: 48,
              height: 0.8,
              color: Color(0xFF70C6BF),
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Mengenal Seni Dendang berarti ikut mengenal '
            'bahasa, budaya, dan identitas masyarakat '
            'Serawai Bengkulu Selatan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: Color(0xFF344057),
            ),
          ),
        ],
      ),
    );
  }
}
