import 'package:flutter/material.dart';
import 'package:KeepNote/database/database_helper.dart';
import 'package:KeepNote/views/drawer/drawer_page.dart';
import 'package:KeepNote/models/notebook.dart';
import 'package:KeepNote/views/note_add_page/note_add_page.dart';
import 'package:KeepNote/utils/app_colors.dart';
import 'package:KeepNote/utils/custom_toast.dart';
import 'package:KeepNote/views/note_update_page/note_update_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = 'Mosfeq Anik';
  String _greeting;
  DatabaseHelper _db;
  bool isLoading;
  List<NoteBook> noteList;
  List<NoteBook> storeNoteList;
  String noData;

  @override
  void initState() {
    super.initState();
    noData = "No note available, add new";
    noteList = [];
    storeNoteList = [];
    isLoading = true;
    _db = DatabaseHelper();
    greetings();
    fetchNoteList();
  }

  void greetings() {
    var timeOfDay = DateTime.now().hour;
    if (timeOfDay >= 0 && timeOfDay < 6) {
      _greeting = 'Good Night';
    } else if (timeOfDay >= 0 && timeOfDay < 12) {
      _greeting = 'Good Morning';
    } else if (timeOfDay >= 12 && timeOfDay < 16) {
      _greeting = 'Good Afternoon';
    } else if (timeOfDay >= 16 && timeOfDay < 21) {
      _greeting = 'Good Evening';
    } else if (timeOfDay >= 21 && timeOfDay < 24) {
      _greeting = 'Good Night';
    }
  }

  Future<void> fetchNoteList() async {
    try {
      var notes = await _db.fetchNoteList();
      if (notes.isNotEmpty) {
        setState(() {
          noteList.addAll(notes);
          storeNoteList.addAll(notes);
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        noteList = [];
        isLoading = false;
      });
    }
  }

  Future<void> showMenuSelection(String value, int id, NoteBook mbook) async {
    switch (value) {
      case 'Delete':
        setState(() {
          isLoading = true;
        });
        deleteConfirmationAlertBox(id);
        break;
      case 'Edit':
        bool isUpdated = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return NoteUpdatePage(
              notebook: mbook,
            );
          }),
        );

        if (isUpdated) {
          setState(() {
            isLoading = true;
          });
          noteList = [];
          fetchNoteList();
        }
        break;
    }
  }

  void filterSearchResult(String query) {
    noteList.clear();
    if (query.isNotEmpty) {
      List<NoteBook> newList = [];
      for (NoteBook noteBook in storeNoteList) {
        if (noteBook.title.toLowerCase().contains(query.toLowerCase()) ||
            noteBook.content.toLowerCase().contains(query.toLowerCase()) ||
            noteBook.date.toLowerCase().contains(query.toLowerCase())) {
          newList.add(noteBook);
        }
      }
      if (newList.isEmpty) {
        setState(() {
          noData = "No data found";
        });
      } else {
        setState(() {
          noteList.addAll(newList);
        });
      }
    } else {
      setState(() {
        noteList.addAll(storeNoteList);
      });
    }
  }

  void showList() {
    noteList = [];
    fetchNoteList();
    Navigator.pop(context);
  }

  void onDelete(int id) async {
    int isDeleted = await _db.deleteNote(id);
    if (isDeleted == 1) {
      CustomToast.toast('Note deleted');
      setState(() {
        isLoading = true;
      });
      showList();
    } else {
      CustomToast.toast('Note not deleted');
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteConfirmationAlertBox(int id) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Delete ALERT",
      desc: "Do You want to delete this Note?",
      buttons: [
        DialogButton(
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => onDelete(id),
          color: Colors.teal,
        ),
        DialogButton(
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => showList(),
          color: Colors.red,
        )
      ],
    ).show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          margin: const EdgeInsets.only(right: 20, bottom: 20),
          child: FloatingActionButton(
              elevation: 0.0,
              child: const Icon(Icons.add),
              backgroundColor: AppColors.qColorPrimary,
              onPressed: () async {
                bool isAdded = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NoteAddPage();
                  }),
                );
                if (isAdded == true) {
                  setState(() {
                    noteList = [];
                    isLoading = true;
                  });
                  fetchNoteList();
                }
              }),
        ),
        body: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'keep',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'Note',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: DrawerPage(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.menu_book,
                          size: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Hello, ' + name,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                        _greeting != null
                            ? Text(
                                _greeting,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontFamily: 'NunitoSans',
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, left: 15, right: 15),
                          height: 55,
                          child: TextField(
                            onChanged: (value) {
                              filterSearchResult(value);
                            },
                            // controller: _editingController,
                            decoration: const InputDecoration(
                              labelText: 'search by title...',
                              prefixIcon: Icon(Icons.search),
                              fillColor: AppColors.qColorLight,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: AppColors.qColorPrimary)),
                              filled: true,
                              contentPadding: EdgeInsets.only(
                                  bottom: 10.0, left: 10.0, right: 10.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        !isLoading
                            ? noteList.contains(null) || noteList.length <= 0
                                ? const Center(
                                    child:
                                        Text("No note available, add new"))
                                : ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 5,
                                    ),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: noteList.length,
                                    itemBuilder: (context, index) {
                                      return noteListItem(noteList[index]);
                                    },
                                  )
                            : const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.qColorPrimary),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Padding noteListItem(NoteBook noteBook) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.qColorBlue2ndPrimary,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      noteBook.title,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      noteBook.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      noteBook.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  showMenuSelection(value, noteBook.id, noteBook);
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                      value: 'Edit',
                      child: ListTile(
                          leading: Icon(Icons.edit), title: Text('Update'))),
                  const PopupMenuItem<String>(
                      value: 'Delete',
                      child: ListTile(
                          leading: Icon(Icons.delete), title: Text('Delete'))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
