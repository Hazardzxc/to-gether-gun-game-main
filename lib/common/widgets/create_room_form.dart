import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:to_gether_gun_game/authentication/email_password/screens/register_screen.dart';
import 'package:to_gether_gun_game/authentication/email_password/utils/authentication.dart';
import 'package:to_gether_gun_game/authentication/email_password/utils/validator.dart';
import 'package:to_gether_gun_game/common/widgets/custom_form_field.dart';
import 'package:to_gether_gun_game/pages/home.dart';
import 'package:to_gether_gun_game/pages/room.dart';
import 'package:to_gether_gun_game/res/custom_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRoomForm extends StatefulWidget {
  final FocusNode roomIdFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode playingDurationFocusNode;

  const CreateRoomForm({
    Key? key,
    required this.roomIdFocusNode,
    required this.passwordFocusNode,
    required this.playingDurationFocusNode,
  }) : super(key: key);
  @override
  CreateRoomFormState createState() => CreateRoomFormState();
}

class CreateRoomFormState extends State<CreateRoomForm> {
  final TextEditingController _roomIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _playingDurationController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final box = GetStorage();
  String docId = Uuid().v1();

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
            child: Column(
              children: [
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
                const SizedBox(height: 12.0),
                CustomFormField(
                  controller: _playingDurationController,
                  focusNode: widget.playingDurationFocusNode,
                  keyboardType: TextInputType.number,
                  inputAction: TextInputAction.done,
                  validator: (value) => Validator.validatePlayingDuration(
                    playingDuration: value,
                  ),
                  isObscure: true,
                  label: 'Playing Duration',
                  hint: 'Enter your Playing Duration',
                ),
              ],
            ),
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
                  widget.playingDurationFocusNode.unfocus();

                  if (_formKey.currentState!.validate()) {
                    final data = {
                      'room_id': _roomIdController.text.trim(),
                      'password': _passwordController.text.trim(),
                      'playing_duration':
                          _playingDurationController.text.trim(),
                      'status': 0,
                      'create_date': DateTime.now(),
                      'create_by': box.read('email'),
                      'member': [
                        {
                          'email': box.read('email'),
                          'name': box.read('name'),
                          'score': 0
                        }
                      ]
                    };

                    FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(docId)
                        .set(data);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เรียบร้อย !')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomScreen(
                          roomDocId: docId,
                        ),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Text(
                    'CREATE',
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
