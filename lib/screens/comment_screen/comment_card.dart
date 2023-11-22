import 'package:flutter/material.dart';
import 'package:instagram_clone/color.dart';
import 'package:intl/intl.dart';

class MyCommentCard extends StatefulWidget {
  final snap;
  const MyCommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<MyCommentCard> createState() => _MyCommentCardState();
}

class _MyCommentCardState extends State<MyCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 9,top: 10),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width*.95,

        child: Padding(
          padding: const EdgeInsets.only(left: 5,right: 5),
          child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.snap['profileurl']),
                  radius: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10,top: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(text: TextSpan(
                          children: [
                            TextSpan(text: widget.snap['username'],style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor),),

                            TextSpan(text: "  ${widget.snap['commenttext']}",style: TextStyle(color: primaryColor),),
                          ]

                        )),
                        SizedBox(height: 4,),
                        Text(DateFormat.yMMMd().format(widget.snap['datetime'].toDate()),style: TextStyle(color: primaryColor,fontSize: 10),)
                      ],
                    ),
                  ),
                ),
                Icon(Icons.favorite,color: primaryColor,size: 17,)
              ],
            ),
        ),


      ),
    );
  }
}
