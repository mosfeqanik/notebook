class NoteBook{
  int id;
  String title;
  String content;
  String date;

  NoteBook({this.id, this.title, this.content, this.date});

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id":id,
      "title":title,
      "content":content,
      "date":date
    };
  }
}
