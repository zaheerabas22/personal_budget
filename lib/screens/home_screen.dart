import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_budget/custom_widgets/colors.dart';
import 'add_edit_budget_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Budgeting App',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.lightText,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bgcolor,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('budget_categories')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                return BudgetCategoryCard(doc: doc);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bgcolor,
        child: const Icon(Icons.add, color: AppColors.lightText),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddEditBudgetScreen()),
          );
        },
      ),
    );
  }
}

class BudgetCategoryCard extends StatelessWidget {
  final DocumentSnapshot doc;

  const BudgetCategoryCard({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditBudgetScreen(doc: doc),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.lightText,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Budgeted: \$${doc['budgeted']}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: AppColors.darkText,
                  ),
                ),
                Text(
                  'Spent: \$${doc['spent']}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditBudgetScreen(doc: doc),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
