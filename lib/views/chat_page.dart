import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat318/providers/auth_service.dart';
import 'package:flutter_appchat318/providers/chat.dart';
import 'package:flutter_appchat318/views/signIn_page.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  TextEditingController mess = TextEditingController(text: "");
  String idRoom;
  Widget build(BuildContext context) {
    idRoom = ModalRoute.of(context).settings.arguments.toString();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Chat()),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Chat Room"),
            leading: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                context.read<AuthService>().signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            reverse: true,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromRGBO(116, 176, 243, 1),
                    Color.fromRGBO(51, 132, 224, 1),
                  ])),
              child: Column(
                children: [
                  messList(idRoom),
                  messInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget toInput() {
  //   return baseInput(to, "TO", Icon(Icons.person), Icon(null), () {});
  // }

  Widget messInput() {
    return baseInput(
        controller: mess,
        text: "Enter message",
        icon: Icon(Icons.file_upload),
        suffixIcon: Icon(Icons.send),
        onTapSuffixIcon: () {
          context.read<Chat>().sendMessage(mess.text, idRoom: idRoom);
          mess.clear();
        },
        onTapPrefixIcon: () {
          context.read<Chat>().selectFile(idRoom);
        });
  }

  Widget messList(String idRoom) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color.fromRGBO(116, 176, 243, 1),
            Color.fromRGBO(51, 132, 224, 1),
          ])),
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(idRoom)
              .orderBy('date')
              .snapshots(includeMetadataChanges: true),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var mess = snapshot.data.docs[index].get("message");
                      var fileName = snapshot.data.docs[index].get("fileName");
                      return ListTile(
                        title: Align(
                          child: fileName == ""
                              ? baseText(
                                  text: mess, color: Colors.black, onTap: () {})
                              : baseText(
                                  text: fileName,
                                  color: Colors.pink,
                                  onTap: () {
                                    context
                                        .read<Chat>()
                                        .dowloadItems(mess, fileName);
                                  },
                                ),
                          alignment: Alignment.topLeft,
                        ),
                      );
                    })
                : Container();
          }),
    );
  }

  Widget baseInput({
    TextEditingController controller,
    String text,
    Icon icon,
    Icon suffixIcon,
    void Function() onTapSuffixIcon,
    void Function() onTapPrefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: TextFormField(
        controller: controller,
        validator: (val) {
          if (val.isEmpty) {
            return 'Không được để trống';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.blue.shade300,
          prefixIcon: InkWell(
            child: icon,
            onTap: onTapPrefixIcon,
          ),
          suffixIcon: InkWell(
            onTap: onTapSuffixIcon,
            child: suffixIcon,
          ),
          hintText: "$text",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget baseText({
    String text,
    double sizeText = 18,
    void Function() onTap,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        "$text",
        style: TextStyle(
          color: color,
          fontSize: sizeText,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

// class MessTile extends StatelessWidget {
//   final String mess;
//   final String time;

//   const MessTile(this.mess, this.time);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
//       child: Container(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(mess),
//                 Text(time),
//               ],
//             ),
//             Spacer(),
//             GestureDetector(
//               onTap: () {},
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Text("Message"),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
