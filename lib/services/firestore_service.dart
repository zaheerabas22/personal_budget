import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget_category.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<BudgetCategory>> getBudgetCategories() {
    return _db.collection('budget_categories').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => BudgetCategory.fromFirestore(doc)).toList());
  }

  Future<void> addBudgetCategory(BudgetCategory category) {
    return _db.collection('budget_categories').add(category.toMap());
  }

  Future<void> updateBudgetCategory(BudgetCategory category) {
    return _db.collection('budget_categories').doc(category.id).update(category.toMap());
  }

  Future<void> deleteBudgetCategory(String id) {
    return _db.collection('budget_categories').doc(id).delete();
  }
}
