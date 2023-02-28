class Message {
  String? text;

  Message({this.text});

  Message.fromJson(data) {
    text = data['text'];
  }
  
}
