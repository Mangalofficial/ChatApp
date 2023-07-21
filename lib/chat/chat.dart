import 'package:chat_app/UI/otherMsg_widget.dart';
import 'package:chat_app/UI/ownMsg_widget.dart';
import 'package:chat_app/chat/msg_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String name;
  final String uid;
  const ChatPage({super.key, required this.name, required this.uid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgcontroller = TextEditingController();
  IO.Socket? socket;
  List<MsgModel> listmsg = [];
  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io("http://localhost:3000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print('Frontend Connected');
      socket!.on("sendMsgServer", (msg) {
        if (msg["userId"] != widget.uid) {
          setState(() {
            listmsg.add(
              MsgModel(
                type: msg["type"],
                msg: msg["msg"],
                sender: msg["sendername"],
              ),
            );
          });
        }
      });
    });
  }

  void sendMsg(String msg, String sendername) {
    MsgModel ownMsg = MsgModel(type: "ownMsg", msg: msg, sender: sendername);
    listmsg.add(ownMsg);
    setState(() {
      listmsg;
    });
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "sendername": sendername,
      "userId": widget.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Group'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: listmsg.length,
                  itemBuilder: (context, index) {
                    if (listmsg[index].type == "ownMsg") {
                      return OwnMsgWidget(
                        sender: listmsg[index].sender,
                        msg: listmsg[index].msg,
                      );
                    } else {
                      return OtherMsgWidget(
                        sender: listmsg[index].sender,
                        msg: listmsg[index].msg,
                      );
                    }
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _msgcontroller,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 23),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                Container(
                  height: 48,
                  width: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.teal,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_msgcontroller.text.isNotEmpty) {
                        sendMsg(_msgcontroller.text, widget.name);
                        _msgcontroller.clear();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
