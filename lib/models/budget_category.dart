import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetCategory {
  String id;
  String name;
  double budgeted;
  double spent;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.budgeted,
    required this.spent,
  });

  factory BudgetCategory.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return BudgetCategory(
      id: doc.id,
      name: data['name'] ?? '',
      budgeted: data['budgeted'] ?? 0.0,
      spent: data['spent'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'budgeted': budgeted,
      'spent': spent,
    };
  }
}
