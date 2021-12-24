import 'package:flutter/material.dart';
import 'package:pondits_notebook/database/database_helper.dart';
import 'package:pondits_notebook/models/notebook.dart';
import 'package:pondits_notebook/utils/app_colors.dart';
import 'package:pondits_notebook/utils/custom_toast.dart';
import 'package:pondits_notebook/utils/date_formatter.dart';

class NoteAddPage extends StatefulWidget {
  @override
  _NoteAddPageState createState() => _NoteAddPageState();
}

class _NoteAddPageState extends State<NoteAddPage> {
  DatabaseHelper _db;
  String _date;
  TextEditingController _titleController;
  TextEditingController _contentController;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    _db = DatabaseHelper();
    _date = DateFormatter.getDateInFormat(
        DateTime.now().toString().substring(0, 10));
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  addNote() async {
    if (_titleController.text == "") {
      CustomToast.toast('Please enter the title');
    } else if (_contentController.text == "") {
      CustomToast.toast('Please enter the content');
    } else if (_date == null) {
      CustomToast.toast('Please select note date');
    } else {
      setState(() {
        isLoading = true;
      });
      NoteBook note = NoteBook(
        title: _titleController.text,
        content: _contentController.text,
        date: _date,
      );
      var isAdded = await _db.addNote(note);
      if (isAdded != null) {
        setState(() {
          isLoading = false;
        });
        CustomToast.toast('Note has been successfully added');
        Navigator.pop(context, true);
      } else {
        setState(() {
          isLoading = false;
        });
        CustomToast.toast('Note can not be added right now');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.qColorPrimary,
        title: Text('Add Note'),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: !isLoading
            ? Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.grey[50],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Text(
                                      'Note Title*',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  child: TextFormField(
                                    maxLines: 1,
                                    controller: _titleController,
                                    decoration: InputDecoration(
                                      hintText: '',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xffbcbcbc),
                                        fontFamily: 'NunitoSans',
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff575757),
                                      fontFamily: 'NunitoSans',
                                    ),
                                    showCursor: true,
                                    cursorColor: AppColors.qColorBlue,
                                    cursorWidth: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.grey[50],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Text(
                                      'Note Content*',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  child: TextFormField(
                                    maxLines: null,
                                    controller: _contentController,
                                    decoration: InputDecoration(
                                      hintText: '',
                                      hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xffbcbcbc),
                                        fontFamily: 'NunitoSans',
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff575757),
                                      fontFamily: 'NunitoSans',
                                    ),
                                    showCursor: true,
                                    cursorColor: AppColors.qColorBlue,
                                    cursorWidth: 1,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.grey[50],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    child: Text(
                                      'Note Date*',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 32, right: 32),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    title: Text(_date),
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1990),
                                        lastDate: DateTime(2050),
                                      ).then((DateTime value) {
                                        if (value != null) {
                                          setState(() {
                                            _date =
                                                DateFormatter.getDateInFormat(
                                                    value
                                                        .toString()
                                                        .substring(0, 10));
                                          });
                                        }
                                      });
                                    },
                                    trailing:
                                        Icon(Icons.calendar_today_rounded),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 25),
                    child: GestureDetector(
                      onTap: () {
                        addNote();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            color: AppColors.qColorPrimary,
                            borderRadius: BorderRadius.circular(8)),
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            'Add Note'.toUpperCase(),
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.qColorPrimary),
                ),
              ),
      ),
    );
  }
}
