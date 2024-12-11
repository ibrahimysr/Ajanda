import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/database_color.dart';


class TaskService {


  List<Map<String, dynamic>> searchTasks(
      List<Map<String, dynamic>> tasks, String query) {
    String lowercaseQuery = query.toLowerCase();

    // Filtrelenmiş görev listesi
    return tasks.where((task) {
      String taskName = task['adı'].toLowerCase();
      return taskName.contains(lowercaseQuery);
    }).toList();
  }

  Future<void> addFavoriData(
      BuildContext context, Map<String, dynamic> doc, User user) async {
    try {
      String userId = user.uid;

      CollectionReference tasksCollection = FirebaseFirestore.instance
          .collection("Kullanıcılar")
          .doc(userId)
          .collection("Favori");

      // Eşsiz bir belge ID oluştur
      String id = tasksCollection.doc().id;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Kullanıcılar").doc(userId);

      Map<String, dynamic> task = {
        "id": id,
        "adı": doc["adı"],
        "baslangıc_tarihi": doc["baslangıc_tarihi"],
        "açıklama": doc["açıklama"],
        "bitis_tarihi": doc["bitis_tarihi"],
        "color_id": doc["color_id"],
        "tamamlandi":
            false, // Başlangıçta tamamlanma durumu false olarak ayarlanır
      };

      await userDoc.update({
        "Favori": FieldValue.arrayUnion([task])
      });

      FirebaseFirestore.instance.collection("Favoriler").add({
        "isim": doc["isim"],
        "detay": doc["detay"],
        "acıklama": doc["acıklama"],
        "fiyat": doc["fiyat"],
      });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> addTask(
      BuildContext context,User user,String taskName,String taskDate,
      String taskDescription,
      String taskDeadline,
      String category) async {
    try {
      String userId = user.uid;
      int colorId = Random().nextInt(DatabaseStyle.cardsColor.length);
      CollectionReference tasksCollection = FirebaseFirestore.instance
          .collection("Kullanıcılar")
          .doc(userId)
          .collection(category);

      String id = tasksCollection.doc().id;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Kullanıcılar").doc(userId);

      Map<String, dynamic> task = {
        "id": id,
        "adı": taskName,
        "baslangıc_tarihi": taskDate,
        "açıklama": taskDescription,
        "bitis_tarihi": taskDeadline,
        "color_id": colorId,
        "tamamlandi":
            false, 
      };
      await userDoc.update({
        category: FieldValue.arrayUnion([task])
      });
    } catch (e) {
      debugPrint("Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.");
    }
  }

  Future<void> deleteTask(BuildContext context, User user,
      Map<String, dynamic> task, String category) async {
    try {
      String userId = user.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Kullanıcılar").doc(userId);

      await userDoc.update({
        category: FieldValue.arrayRemove([task])
      });
    } catch (e) {
      debugPrint("Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.");
    }
  }

  Future<void> updateTask(
      BuildContext context,
      User user,
      Map<String, dynamic> task,
      String taskName,
      String taskDate,
      String taskDescription,
      String taskDeadline,
      String category) async {
    try {
      String userId = user.uid;
      String taskId = task['id']; // Mevcut görevin ID'si

      // Kullanıcının belge referansı
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Kullanıcılar").doc(userId);

      // Mevcut görevin güncellenecek alanları
      Map<String, dynamic> updatedFields = {
        "id": taskId,
        "adı": taskName,
        "baslangıc_tarihi": taskDate,
        "açıklama": taskDescription,
        "bitis_tarihi": taskDeadline,
        "tamamlandi": task["tamamlandi"], // Tamamlanma durumu korunur
      };

      await userDoc.update({
        category: FieldValue.arrayRemove([task]), // Mevcut görevi kaldır
      });

      await userDoc.update({
        category:
            FieldValue.arrayUnion([updatedFields]), // Güncellenmiş görevi ekle
      });
    } catch (e) {
      debugPrint("Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.");
    }
  }

  Future<void> completeTask(BuildContext context, User user,
      Map<String, dynamic> task, String category, bool check) async {
    try {
      String userId = user.uid;
      String taskId = task['id'];

      // Kullanıcının belge referansı
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("Kullanıcılar").doc(userId);

      // Mevcut görevin güncellenecek alanları
      Map<String, dynamic> updatedFields = {
        "id": taskId,
        "adı": task["adı"],
        "baslangıc_tarihi": task["baslangıc_tarihi"],
        "açıklama": task["açıklama"],
        "bitis_tarihi": task["bitis_tarihi"],
        "color_id": task["color_id"],
        "tamamlandi":
            check ? false : true, // Görev tamamlandı olarak işaretlenir
      };

      await userDoc.update({
        category: FieldValue.arrayRemove([task]),
      });

      await userDoc.update({
        category: FieldValue.arrayUnion([updatedFields]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(check
                ? 'Görev tamamlananlardan çıkarıldı.'
                : "Görev Tamamlandı")),
      );
    } catch (e) {
      debugPrint("Beklenmedik bir hata oluştu. Lütfen tekrar deneyin.");
    }
  }

  Stream<List<Map<String, dynamic>>> getTasksStream(
      User user, String category, bool showPastDue, bool completedTasksOnly) {
    String userId = user.uid;

    return FirebaseFirestore.instance
        .collection("Kullanıcılar")
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> tasks =
          List<Map<String, dynamic>>.from(snapshot.get(category));

      if (completedTasksOnly) {
        tasks = _filterCompletedTasks(tasks);
      } else if (showPastDue) {
        tasks = _filterPastDueTasks(tasks);
      } else {
        tasks = _filterCurrentTasks(tasks);
      }

      return tasks;
    });
  }

  List<Map<String, dynamic>> _filterCompletedTasks(
      List<Map<String, dynamic>> tasks) {
    List<Map<String, dynamic>> completedTasks = [];

    for (var task in tasks) {
      // Assuming there is a field like 'completed' in your task data
      if (task['tamamlandi'] == true) {
        completedTasks.add(task);
      }
    }

    return completedTasks;
  }

  List<Map<String, dynamic>> _filterCurrentTasks(
      List<Map<String, dynamic>> tasks) {
    List<Map<String, dynamic>> currentTasks = [];

    for (var task in tasks) {
      DateTime deadline = DateTime.parse(task['bitis_tarihi']);
      if (deadline.isAfter(DateTime.now()) ||
          deadline.isAtSameMomentAs(DateTime.now())) {
        // Assuming there is a field like 'completed' in your task data
        if (task['tamamlandi'] != true) {
          currentTasks.add(task);
        }
      }
    }

    return currentTasks;
  }

  List<Map<String, dynamic>> _filterPastDueTasks(
      List<Map<String, dynamic>> tasks) {
    List<Map<String, dynamic>> pastDueTasks = [];

    for (var task in tasks) {
      DateTime deadline = DateTime.parse(task['bitis_tarihi']);
      if (deadline.isBefore(DateTime.now())) {
        // Assuming there is a field like 'completed' in your task data
        if (task['tamamlandi'] != true) {
          pastDueTasks.add(task);
        }
      }
    }

    return pastDueTasks;
  }
}
