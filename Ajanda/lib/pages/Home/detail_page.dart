import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/add_task_textfield.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> task;
  final String selectCategory;

  const DetailPage(
      {super.key, required this.task, required this.selectCategory});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDate = TextEditingController();
  TextEditingController taskDetail = TextEditingController();
  TextEditingController taskDeadline = TextEditingController();
  TextEditingController taskDeadlineTime = TextEditingController();
  final ValueNotifier<String> selectedTaskType = ValueNotifier<String>('Görev');

  static String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void getinformations() {
    // Automatically update taskDate controller
    DateTime now = DateTime.now();
    taskDate.text =
        "${now.toLocal().toString().split(' ')[0]} ${_formatTime(TimeOfDay(hour: now.hour, minute: now.minute))}";
    taskDeadline.clear(); // Clear task deadline
    taskName.text = widget.task["adı"];
    taskDetail.text = widget.task["açıklama"];
    taskDeadline.text = widget.task["bitis_tarihi"].toString().split(" ")[0];
    taskDeadlineTime.text =
        widget.task["bitis_tarihi"].toString().split(" ")[1];
    selectedTaskType.value = widget.selectCategory;
  }

  @override
  void initState() {
    super.initState();
    getinformations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff0f0fa),
      appBar: AppBar(
        backgroundColor: const Color(0xfff0f0fa),
        elevation: 0,
        title:  Text(
          'Detay Sayfası',
          style: AppStyle.mainTitle.copyWith( 
            fontSize: 25
          )      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Başlık',
              style: AppStyle.mainTitle.copyWith( 
                fontSize: 16
              )
            ),
            addTaskTextfield('Title', taskName, 'Başlık', 1, context),
             Text(
              'Detay',
              style: AppStyle.mainTitle.copyWith( 
                fontSize: 16
              )
            ),
            addTaskTextfield2('Detay', taskDetail, 'Detay Giriniz', 3, context),
             Text(
              'Başlangıç Tarihi',
              style:AppStyle.mainTitle.copyWith( 
                fontSize: 16
              )
            ),
            addTaskTextfield(
                'Başlangıç Tarihi', taskDate, 'Başlık', 1, context),
             Text(
              'Bitiş Tarihi',
              style: AppStyle.mainTitle.copyWith( 
                fontSize: 16
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            style: const TextStyle(color: textColor),
                            controller: taskDeadline,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Color(0xff282C34),
                                hintText: "Tarih",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            style: const TextStyle(color: textColor),
                            controller: taskDeadlineTime,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Color(0xff282C34),
                                hintText: "Saat",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
             Text(
              'Kategori',
              style: AppStyle.mainTitle.copyWith( 
                fontSize: 16
              )
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ValueListenableBuilder<String>(
                  valueListenable: selectedTaskType,
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedTaskType.value,
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
                          items: <String>['Not', 'Toplantı', 'Görev']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTaskType.value = newValue!;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
