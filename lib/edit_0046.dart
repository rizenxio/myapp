import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Edit_0046 extends StatefulWidget {
  final Map<String, dynamic> expenseData;

  const Edit_0046({Key? key, this.expenseData = const {}}) : super(key: key);

  @override
  State<Edit_0046> createState() => _Edit_0046State();
}

class _Edit_0046State extends State<Edit_0046> {
  late String? expenseTitle;
  late String? expenseCategory;
  late String? expenseNote;
  late String? expenseDate;
  late int? expenseAmount;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    expenseTitle = widget.expenseData['expenseTitle'];
    expenseCategory = widget.expenseData['expenseCategory'];
    expenseNote = widget.expenseData['expenseNote'];
    expenseDate = widget.expenseData['expenseDate'];
    expenseAmount = widget.expenseData['expenseAmount'];
    _dateController.text = expenseDate ?? '';
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> updateData() async {
    if (_formKey.currentState!.validate()) {
      try {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("MyExpenses")
            .doc(expenseTitle);

        Map<String, dynamic> updatedData = {
          "expenseTitle": expenseTitle,
          "expenseAmount": expenseAmount,
          "expenseCategory": expenseCategory,
          "expenseNote": expenseNote,
          "expenseDate": expenseDate,
        };

        await documentReference.update(updatedData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating data: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: expenseTitle,
                            decoration: InputDecoration(
                              labelText: "Title",
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Title is required";
                              }
                              return null;
                            },
                            onChanged: (value) => expenseTitle = value,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: expenseAmount?.toString(),
                            decoration: InputDecoration(
                              labelText: "Amount (Rp)",
                              prefixIcon: Icon(Icons.attach_money),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Amount is required";
                              }
                              if (int.tryParse(value) == null) {
                                return "Enter a valid number";
                              }
                              return null;
                            },
                            onChanged: (value) => expenseAmount = int.tryParse(value),
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: expenseCategory,
                            decoration: InputDecoration(
                              labelText: "Category",
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(value: "Pemasukan", child: Text("Pemasukan")),
                              DropdownMenuItem(value: "Pengeluaran", child: Text("Pengeluaran")),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Category is required";
                              }
                              return null;
                            },
                            onChanged: (value) => expenseCategory = value,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Date",
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Date is required";
                              }
                              return null;
                            },
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                setState(() {
                                  expenseDate = formattedDate;
                                  _dateController.text = formattedDate;
                                });
                              }
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: expenseNote,
                            decoration: InputDecoration(
                              labelText: "Notes",
                              prefixIcon: Icon(Icons.note),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Notes is required";
                              }
                              return null;
                            },
                            onChanged: (value) => expenseNote = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: updateData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Update Expense",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}