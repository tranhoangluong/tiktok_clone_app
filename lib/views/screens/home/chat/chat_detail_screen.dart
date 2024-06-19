import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toptop/database/service/chat_service.dart';
import 'package:toptop/database/service/storage_service.dart';
import 'package:toptop/provider/loading_model.dart';
import 'package:toptop/provider/save_model.dart';
import 'package:toptop/views/screens/home/user/people_detail_screen.dart';
import 'package:toptop/views/widget/colors.dart';
import 'package:toptop/views/widget/text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';

class ChatDetailScreen extends StatefulWidget {
  final String peopleID;
  final String peopleName;
  final String ChatID;
  final String peopleImage;
  final BuildContext? contextBackPage;

  const ChatDetailScreen({
    super.key,
    required this.peopleID,
    required this.peopleName,
    required this.peopleImage,
    required this.ChatID,
    this.contextBackPage,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState(
      this.peopleID, this.peopleName, this.ChatID, this.peopleImage);
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final peopleID;
  final peopleName;
  final peopleImage;
  final ChatID;
  final currentUserID = FirebaseAuth.instance.currentUser?.uid;
  var chatDocID;
  final TextEditingController _textEditingController = TextEditingController();

  _ChatDetailScreenState(
      this.peopleID, this.peopleName, this.ChatID, this.peopleImage);

  void sendMessage(String message, String peopleChatID, String type) {
    if (message == '') return;
    chats.doc(ChatID).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uID': currentUserID,
      'content': message,
      'type': type
    }).then((value) async {
      _textEditingController.text = '';

      try {
        List<dynamic> data = await ChatService.getUserPeopleChatID(
            currentUserID: currentUserID.toString());
        List<String>? listPeoPleChatID =
            (data).map((e) => e as String).toList();
        if (listPeoPleChatID != null) {
          for (int i = 0; i < listPeoPleChatID.length; i++) {
            if (peopleChatID == listPeoPleChatID[i]) {
              return;
            }
          }
          final CollectionReference users =
              FirebaseFirestore.instance.collection('users');
          users.doc(currentUserID).update({
            'myChatPeopleID': FieldValue.arrayUnion([peopleChatID]),
          });
        }
      } catch (e) {
        final CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        users.doc(currentUserID).update({
          'myChatPeopleID': FieldValue.arrayUnion([peopleChatID]),
        });
      }
    });
  }

  bool isSender(String sender) {
    return sender == currentUserID;
  }

  Alignment getAligment(sender) {
    if (sender == currentUserID) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  Future<File?> getImage(ImageSource src) async {
    var _picker = await ImagePicker().pickImage(source: src);
    if (_picker != null) {
      File? imageFile = File(_picker.path);
      return imageFile;
    }
    return null;
  }

  showOptionsDialog(BuildContext context, String url) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              StorageServices.saveFile(url);
              Navigator.of(context).pop();
            },
            child: const Row(
              children: [
                Icon(Icons.save_alt),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop(),
            child: const Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<LoadingModel>().isLoading = false;
    context.read<SaveModel>().isSaving = 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: 50,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PeopleInfoScreen(peopleID: peopleID)),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(peopleImage),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              child: CustomText(
                alignment: Alignment.center,
                fontsize: 20,
                maxLines: 2,
                text: peopleName,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
        toolbarHeight: 150,
        shadowColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            widget.contextBackPage?.read<LoadingModel>().changeBack();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: MyColors.thirdColor,
        actions: const [
          // Icon(
          //   Icons.call_outlined,
          //   color: MyColors.mainColor,
          // ),
        ],
      ),
      backgroundColor: MyColors.thirdColor,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chats')
              .doc(ChatID)
              .collection('messages')
              .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black87.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            var data = document.data()! as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: data['type'] == 'image'
                                            ? GestureDetector(
                                                onLongPress: () {
                                                  showOptionsDialog(
                                                      context, data['content']);
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  alignment: isSender(
                                                          data['uID']
                                                              .toString())
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                                  child: Image.network(
                                                    data['content'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : BubbleSpecialThree(
                                                text: data['content'],
                                                color: isSender(
                                                        data['uID'].toString())
                                                    ? MyColors.thirdColor
                                                    : Colors.grey.shade300,
                                                tail: true,
                                                isSender: isSender(
                                                    data['uID'].toString()),
                                                textStyle: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontFamily: 'Poppins'),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data['createdOn'] == null
                                            ? DateTime.now().toString()
                                            : DateFormat.yMMMd()
                                                .add_jm()
                                                .format(
                                                    data['createdOn'].toDate()),
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Consumer<LoadingModel>(
                    builder: (_, isLoadingImage, __) {
                      if (isLoadingImage.isLoading) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () async {
                                context.read<LoadingModel>().changeLoading();
                                File? fileImage =
                                    await getImage(ImageSource.camera);
                                if (fileImage == null) {
                                  context.read<LoadingModel>().changeLoading();
                                } else {
                                  String fileName =
                                      await StorageServices.uploadImage(
                                          fileImage);
                                  sendMessage(fileName, peopleID, 'image');
                                  try {
                                    context
                                        .read<LoadingModel>()
                                        .changeLoading();
                                  } catch (e) {}
                                }
                              },
                              icon: Icon(
                                Icons.enhance_photo_translate,
                                color: MyColors.thirdColor,
                              )),
                          IconButton(
                              onPressed: () async {
                                context.read<LoadingModel>().changeLoading();
                                File? fileImage =
                                    await getImage(ImageSource.gallery);
                                if (fileImage == null) {
                                  context.read<LoadingModel>().changeLoading();
                                } else {
                                  String fileName =
                                      await StorageServices.uploadImage(
                                          fileImage);
                                  sendMessage(fileName, peopleID, 'image');
                                  try {
                                    context
                                        .read<LoadingModel>()
                                        .changeLoading();
                                  } catch (e) {}
                                }
                              },
                              icon: Icon(Icons.image_outlined,
                                  color: MyColors.thirdColor)),
                          Expanded(
                            child: Container(
                              height: 45,
                              child: TextField(
                                controller: _textEditingController,
                                textAlignVertical: TextAlignVertical.bottom,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: MyColors.thirdColor,
                                    ),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  hintText: "Type here ...",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      sendMessage(_textEditingController.text,
                                          peopleID, 'text');
                                    },
                                    icon: Icon(
                                      Icons.send_rounded,
                                      color: MyColors.thirdColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     sendMessage(_textEditingController.text);
                          //   },
                          //   icon: Icon(
                          //     Icons.send_outlined,
                          //     color: MyColors.mainColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('Failed!'),
            );
          }),
    );
  }
}
