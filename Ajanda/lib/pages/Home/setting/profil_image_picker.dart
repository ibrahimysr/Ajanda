import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/login_button.dart';

class ProfileImagePickerPage extends StatefulWidget {
  const ProfileImagePickerPage({super.key});

  @override
  _ProfileImagePickerPageState createState() => _ProfileImagePickerPageState();
}

class _ProfileImagePickerPageState extends State<ProfileImagePickerPage> {
  File? _imageFile;
  final picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String fileName = 'profile_${user.uid}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask = storageRef.putFile(_imageFile!);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Firestore'a URL'yi kaydet
      await FirebaseFirestore.instance.collection('Kullanıcılar').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
      });

      Navigator.pop(context, downloadUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil resmi yüklenirken bir hata oluştu: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      appBar: AppBar(
        title: Text('Profil Resmi Seç', style: AppStyle.mainContent.copyWith(color: textColor, fontSize: 20)),
        centerTitle: true,
        backgroundColor: appcolor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text('Resim Seçilmedi', style: AppStyle.mainContent.copyWith(color: textColor, fontSize: 20))
                : Image.file(
                    _imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 20.0),
            loginButton("Galeriden Seç", () => _pickImage(ImageSource.gallery)),
            const SizedBox(height: 20.0),
            loginButton("Kameradan Seç", () => _pickImage(ImageSource.camera)),
            const SizedBox(height: 20.0),
            SizedBox(
              width: 300,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(width: 2, color: appcolor2),
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  shape: const StadiumBorder(),
                  backgroundColor: enabledColor,
                ),
                onPressed: _isUploading ? null : _uploadImage,
                child: _isUploading ? const CircularProgressIndicator() : Text('Yüklemeyi Tamamla', style: AppStyle.mainContent.copyWith(color: appcolor2, fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
