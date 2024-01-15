import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat/components/svg_icon.dart';
import 'package:private_chat/models/user_model.dart';
import 'package:private_chat/providers/user_provider.dart';
import 'package:private_chat/services/api_services.dart';

class ProfileDialog extends ConsumerStatefulWidget {
  const ProfileDialog({super.key});

  @override
  ConsumerState<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends ConsumerState<ProfileDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserModel? user = ref.watch(userProvider);
    return AlertDialog(
      backgroundColor: const Color(0xff111216),
      content: Stack(
        alignment: Alignment.topRight,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(42),
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(42)),
                child: const Icon(Icons.close),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                  height: size.height * 0.25,
                  width: double.infinity,
                  child: Center(child: userDetails(user!, size)))
            ],
          ),
        ],
      ),
    );
  }

  Widget userDetails(
    UserModel user,
    Size size,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.topCenter,
          height: size.height * 0.08,
          width: size.height * 0.08,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.height * 0.05),
              color: Colors.amber),
          child: const Center(
            child: SvgIcon(
              'assets/icons/user_white_bg.svg',
              size: 52,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                // const SizedBox(width: 5,),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showNameChangeDialog(size, user.name, user.phone);
                    },
                    borderRadius: BorderRadius.circular(36),
                    child: Container(
                      padding: const EdgeInsets.only(top: 4),
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: const SvgIcon(
                        'assets/icons/Pen.svg',
                        size: 19,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Flexible(
              child: Text(
                'Phone: ${user.phone}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ],
        )
      ],
    );
  }

  showNameChangeDialog(Size size, String name, String phone) {
    TextEditingController controller = TextEditingController(text: name);
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Container(
              height: 8,
            ),
            backgroundColor: const Color(0xff111216),
            content: content(size, controller),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () async {
                    if (controller.text.trim().isNotEmpty) {
                      UserModel newU = UserModel(
                          name: controller.text.trim(),
                          phone: phone,
                          id: ref.watch(userIdProvider));
                      bool res = await ApiService()
                          .updateUser(newU, ref.watch(userIdProvider));

                      if (!res) {
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Center(
                            child: Text("Something went wrong!"),
                          )));
                        }
                        return;
                      }

                      ref.read(userProvider.notifier).state = newU;
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Center(
                          child: Text('Name has been changed'),
                        )));
                      }
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

  Widget content(Size size, TextEditingController controller) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Name can\'t be null';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          label: const Text('Enter New Name'),
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
