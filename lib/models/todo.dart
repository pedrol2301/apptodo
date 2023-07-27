class Todo {
  Todo({required this.title, required this.datetime});
  String title;
  DateTime datetime;
  bool finished = false;

  Todo.fromJson(Map<String, dynamic> json)
  : title = json['title'],
    datetime = DateTime.parse(json['datetime']),
    finished = json['finished'];

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'datetime': datetime.toIso8601String(),
      'finished': finished
    };
  }
}