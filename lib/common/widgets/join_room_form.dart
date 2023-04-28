import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_gether_gun_game/authentication/email_password/utils/validator.dart';
import 'package:to_gether_gun_game/common/widgets/custom_form_field.dart';
import 'package:to_gether_gun_game/pages/room.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinRoomForm extends StatefulWidget {
  final FocusNode roomIdFocusNode;
  final FocusNode passwordFocusNode;

  const JoinRoomForm({
    Key? key,
    required this.roomIdFocusNode,
    required this.passwordFocusNode,
  }) : super(key: key);
  @override
  JoinRoomFormState createState() => JoinRoomFormState();
}

class JoinRoomFormState extends State<JoinRoomForm> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 14.0,
            ),
            child: Column(children: [
              CustomFormField(
                controller: _roomIdController,
                focusNode: widget.roomIdFocusNode,
                keyboardType: TextInputType.number,
                inputAction: TextInputAction.next,
                validator: (value) => Validator.validateRoomId(
                  roomId: value,
                ),
                label: 'Room id',
                hint: 'Enter your Room id',
              ),
              const SizedBox(height: 12.0),
              CustomFormField(
                controller: _passwordController,
                focusNode: widget.passwordFocusNode,
                keyboardType: TextInputType.text,
                inputAction: TextInputAction.done,
                validator: (value) => Validator.validatePassword(
                  password: value,
                ),
                isObscure: true,
                label: 'Room password',
                hint: 'Enter your Room password',
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Palette.firebaseOrange,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  widget.roomIdFocusNode.unfocus();
                  widget.passwordFocusNode.unfocus();

                  if (_formKey.currentState!.validate()) {
                    List? member = [];
                    FirebaseFirestore.instance
                        .collection('rooms')
                        .where('room_id',
                            isEqualTo: _roomIdController.text.trim())
                        .where('password',
                            isEqualTo: _passwordController.text.trim())
                        .where("status", isEqualTo: 0)
                        .get()
                        .then(
                      (querySnapshot) {
                        if (querySnapshot.docs.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'ไม่พบ Rooms! หรือเกมส์ได้เริ่มไปแล้ว')),
                          );
                        } else {
                          for (var docSnapshot in querySnapshot.docs) {
                            // print('${docSnapshot.id} => ${docSnapshot.data()}');
                            final data =
                                docSnapshot.data() as Map<String, dynamic>;
                            member = data['member'] is Iterable
                                ? List.from(data['member'])
                                : null;

                            // print('${docId} => ${member}');
                            member?.add({
                              'email': box.read('email'),
                              'name': box.read('name'),
                              'score': 0
                            });

                            CollectionReference rooms =
                                FirebaseFirestore.instance.collection('rooms');
                            rooms
                                .doc(docSnapshot.id)
                                .update({'member': member});
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('เรียบร้อย !')),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomScreen(
                                  roomDocId: docSnapshot.id,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      onError: (e) => print("Error completing: $e"),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'JOIN',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Palette.firebaseGrey,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
