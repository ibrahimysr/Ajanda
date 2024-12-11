import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ErrorReportDialog extends StatefulWidget {
  const ErrorReportDialog({super.key});

  @override
  _ErrorReportDialogState createState() => _ErrorReportDialogState();
}

class _ErrorReportDialogState extends State<ErrorReportDialog> {
  final TextEditingController _messageController = TextEditingController();

  void _sendErrorReport(String errorMessage) {
    if (errorMessage.isNotEmpty) {
      // Firestore'a hataları eklemek için Firestore referansı alınır
      CollectionReference errors =
          FirebaseFirestore.instance.collection('hatalar');

      // Hata belgesi eklenir
      errors.add({
        'hataMesaji': errorMessage,
        'tarih': DateTime.now(),
      }).then((value) {
        // Başarılı bir şekilde eklendikten sonra kullanıcıya geri bildirim verilir
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hata Bildirimi'),
              content: const Text('Hata başarıyla gönderildi!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }).catchError((error) {
        // Hata ekleme sırasında bir hata oluşursa kullanıcıya bildirim verilir
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hata Bildirimi'),
              content: Text('Hata gönderilirken bir sorun oluştu: $error'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Tamam'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hata Bildirimi'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Hata Bildirimi'),
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _messageController,
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
                                _sendErrorReport(_messageController.text);
                                _messageController.clear();
                                Navigator.of(context).pop();
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
          },
          child: const Text('Hata Bildir'),
        ),
      ),
    );
  }
}
