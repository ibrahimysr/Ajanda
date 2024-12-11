import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showReportDialog(BuildContext context) {
  TextEditingController messageController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Hata Bildirimi'),
        content: SizedBox(
          height: 200, // Yükseklik ayarlanabilir
          child: Column(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: messageController,
                  maxLines: null, // Birden fazla satıra izin verir
                  decoration: const InputDecoration(
                    hintText: 'Hata mesajınızı buraya yazın',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      // Hata mesajını Firebase'e gönderme işlemi
                      _sendErrorReport(context, messageController.text);
                    },
                    child: const Text('Gönder'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Geri'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _sendErrorReport(BuildContext context, String errorMessage) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('Error: User not authenticated');
      return;
    }

    CollectionReference errorReports =
        FirebaseFirestore.instance.collection('Hata Bildirimleri');

    await errorReports.add({
      'userId': user.uid,
      'KullanıcıId': user.displayName ?? 'Anonymous',
      'Hata_mesajı': errorMessage,
      'zaman': Timestamp.now(),
    });

    debugPrint('Error report sent successfully');
    Navigator.of(context).pop();
  } catch (e) {
    debugPrint('Error sending error report: $e');
  }
}
