import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Input_0046 extends StatefulWidget {
  const Input_0046({super.key});

  @override
  State<Input_0046> createState() => _Input_0046State();
}

class _Input_0046State extends State<Input_0046> {
  String? expenseTitle, expenseCategory, expenseNote, expenseDate;
  int? expenseAmount;
  final _formKey = GlobalKey<FormState>();

  getexpenseTitle(String title) {
    this.expenseTitle = title;
  }

  getexpenseCategory(String category) {
    this.expenseCategory = category;
  }

  getexpenseNote(String note) {
    this.expenseNote = note;
  }

  getexpenseDate(String date) {
    this.expenseDate = date;
  }

  getexpenseAmount(String amount) {
    this.expenseAmount = int.parse(amount);
  }

  void createdData() async {
    if (_formKey.currentState!.validate()) {
      try {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection("MyExpenses")
            .doc(expenseTitle);

        Map<String, dynamic> students = {
          "expenseTitle": expenseTitle,
          "expenseAmount": expenseAmount,
          "expenseCategory": expenseCategory,
          "expenseNote": expenseNote,
          "expenseDate": expenseDate,
        };

        await documentReference.set(students);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Data berhasil dibuat!"),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/lihat');
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
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
        title: Text(
          "Add Expense",
          style: TextStyle(color: Colors.white),
        ),
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
                            decoration: InputDecoration(
                              labelText: "Title",
                              prefixIcon: Icon(Icons.title),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            onChanged: getexpenseTitle,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
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
                                return 'Please enter an amount';
                              }
                              return null;
                            },
                            onChanged: getexpenseAmount,
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Category",
                              prefixIcon: Icon(Icons.category),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: "Pemasukan",
                                child: Text("Pemasukan"),
                              ),
                              DropdownMenuItem(
                                value: "Pengeluaran",
                                child: Text("Pengeluaran"),
                              ),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                            onChanged: (String? category) {
                              if (category != null) {
                                getexpenseCategory(category);
                              }
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller:
                                TextEditingController(text: expenseDate ?? ''),
                            decoration: InputDecoration(
                              labelText: "Date",
                              prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (expenseDate == null) {
                                return 'Please select a date';
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
                                });
                              }
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Notes",
                              prefixIcon: Icon(Icons.note),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLines: 3,
                            onChanged: getexpenseNote,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: createdData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Save Expense",
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
