import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({required this.send, super.key});

  final VoidCallback send;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: send,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color.fromARGB(255, 50, 153, 101)),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Icon(
            Icons.send_rounded,
            size: 30,
            color: const Color(0xff000000).withOpacity(0.8),
          ),
        )),
      ),
    );
  }
}
