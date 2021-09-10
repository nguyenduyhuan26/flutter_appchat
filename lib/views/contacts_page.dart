import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat318/providers/auth_service.dart';
import 'package:flutter_appchat318/providers/chat.dart';
import 'package:flutter_appchat318/views/chat_page.dart';
import 'package:flutter_appchat318/views/signIn_page.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  String userEmail1;
  @override
  Widget build(BuildContext context) {
    userEmail1 = ModalRoute.of(context).settings.arguments.toString();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Chat()),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Contact"),
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
          body: Column(
            children: [
              userList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(116, 176, 243, 1),
              Color.fromRGBO(51, 132, 224, 1),
            ])),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        var userName = snapshot.data.docs[index].get("name");
                        var userEmail = snapshot.data.docs[index].get("email");
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  baseText(text: userName),
                                  baseText(text: userEmail),
                                ],
                              ),
                              GestureDetector(
                                  onTap: () {
                                    context
                                        .read<Chat>()
                                        .checkIdRoom(userEmail, userEmail1)
                                        .then((value) {
                                      if (value.isNotEmpty) {
                                        print("Room Ok");
                                        print(value);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(),
                                            settings: RouteSettings(
                                              arguments: value,
                                            ),
                                          ),
                                        );
                                      } else {
                                        print("Create");
                                        context.read<Chat>().createRoomChat(
                                            "$userEmail1-$userEmail");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatPage(),
                                            settings: RouteSettings(
                                              arguments:
                                                  "$userEmail1-$userEmail",
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                    // print(context
                                    //     .read<Chat>()
                                    //     .checkIdRoom(userEmail, userEmail1));
                                    // print(idRoom);

                                    // context
                                    //     .read<Chat>()
                                    //     .createChatRoom(userEmail1, userEmail);

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => ChatPage(),
                                    //     ));
                                    // context
                                    //     .read<Chat>()
                                    //     .dowloadItems("urlDownload", "fileName");
                                  },
                                  child: Icon(Icons.send))
                            ],
                          ),
                        );
                      })
                  : Container();
            }),
      ),
    );
  }

  Widget baseText({
    String text,
    double sizeText = 18,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      "$text",
      style: TextStyle(
        color: color,
        fontSize: sizeText,
        fontWeight: fontWeight,
      ),
    );
  }
}
