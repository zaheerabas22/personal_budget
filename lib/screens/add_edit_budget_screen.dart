import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_budget/custom_widgets/colors.dart';

class AddEditBudgetScreen extends StatefulWidget {
  final DocumentSnapshot? doc;

  const AddEditBudgetScreen({super.key, this.doc});

  @override
  _AddEditBudgetScreenState createState() => _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends State<AddEditBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetedController = TextEditingController();
  final _spentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.doc != null) {
      _nameController.text = widget.doc!['name'];
      _budgetedController.text = widget.doc!['budgeted'].toString();
      _spentController.text = widget.doc!['spent'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doc == null ? 'Add Budget Category' : 'Edit Budget Category',
          style: GoogleFonts.playfairDisplay(
            color: AppColors.lightText,
          ),
        ),
        backgroundColor: AppColors.bgcolor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.lightText,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Category Name',
                icon: Icons.category,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _budgetedController,
                label: 'Budgeted Amount',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _spentController,
                label: 'Spent Amount',
                icon: Icons.money_off,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton(
                    label: 'Save',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          if (widget.doc == null) {
                            await FirebaseFirestore.instance
                                .collection('budget_categories')
                                .add({
                              'name': _nameController.text,
                              'budgeted':
                                  double.parse(_budgetedController.text),
                              'spent': double.parse(_spentController.text),
                            });
                            print('Data added successfully');
                          } else {
                            await widget.doc!.reference.update({
                              'name': _nameController.text,
                              'budgeted':
                                  double.parse(_budgetedController.text),
                              'spent': double.parse(_spentController.text),
                            });
                            print('Data updated successfully');
                          }
                          Navigator.pop(context);
                        } catch (e) {
                          print('Failed to add/update data: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save data: $e')),
                          );
                        }
                      }
                    },
                    color: AppColors.primary,
                  ),
                  _buildButton(
                    label: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: const Color.fromARGB(216, 244, 67, 54),
                    textColor: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.playfairDisplay(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
    Color textColor = Colors.white,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
