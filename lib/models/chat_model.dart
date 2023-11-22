class MyChatModel{
  late String from;
  late String to;
  late String message;
  late String docid;
  final date;

  MyChatModel({required this.from,required this.message,required this.to,required this.docid,required this.date});
Map<String,dynamic> tojson()=>{
  "from":from,
  "to":to,
  "massage":message,
  "docid":docid,
  "date":date
};
}