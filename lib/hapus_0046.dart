import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Hapus_0046 extends StatelessWidget {
  const Hapus_0046({Key? key}) : super(key: key);

  void deleteData(String expenseTitle, BuildContext context) async {
    try {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("MyExpenses").doc(expenseTitle);

      await documentReference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Data berhasil dihapus!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hapus pengeluaran"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("MyExpenses").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }

            return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                // Anda bisa menyesuaikan icon berdasarkan data atau menggunakan icon default
                return ListTile(
                  leading:
                      Icon(Icons.attach_money), // Bisa disesuaikan dengan data
                  title: Text(data["expenseCategory"] ?? ""),
                  subtitle: Text(
                      "Rp.${data["expenseAmount"]} - ${data["expenseTitle"]}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deleteData(data["expenseTitle"], context);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
