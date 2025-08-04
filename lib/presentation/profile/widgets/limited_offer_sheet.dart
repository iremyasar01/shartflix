import 'package:flutter/material.dart';
import 'package:shartflix/presentation/profile/widgets/bonus_item.dart';
import 'package:shartflix/presentation/profile/widgets/jeton_card.dart';

class LimitedOfferSheet extends StatelessWidget {
  const LimitedOfferSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text(
                  'Sınırlı Teklif',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jeton paketin\'ni seçerek bonus kazanın ve yeni bölümlerin kilidini açın!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 24),

                // BONUS ICONLARI
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BonusItem(icon: Icons.diamond, title: "Premium\nHesap"),
                      BonusItem(
                          icon: Icons.favorite, title: "Daha\nFazla Eşleşme"),
                      BonusItem(icon: Icons.upload, title: "Öne\nÇıkarma"),
                      BonusItem(
                          icon: Icons.favorite_border,
                          title: "Daha\nFazla Beğeni"),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Kilidi açmak için bir jeton paketi seçin',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 16),

                // JETON PAKETLERİ
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JetonCard(
                      bonus: "+10%",
                      current: "330",
                      old: "200",
                      price: "₺99,99",
                      color: Colors.redAccent,
                    ),
                    JetonCard(
                      bonus: "+70%",
                      current: "3.375",
                      old: "2.000",
                      price: "₺799,99",
                      color: Colors.blueAccent,
                    ),
                    JetonCard(
                      bonus: "+35%",
                      current: "1.350",
                      old: "1.000",
                      price: "₺399,99",
                      color: Colors.redAccent,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tüm Jetonları Gör
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Tüm Jetonları Gör',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
