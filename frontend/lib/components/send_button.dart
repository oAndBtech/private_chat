import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({
    required this.send,
    super.key
    });

    final VoidCallback send; 

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: send,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: width * 0.135,
        height: width * 0.135,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 50, 153, 101)
        ),
        child: Center(child: Icon(Icons.send,color: Color(0xff000000).withOpacity(0.8),)),
      ),
    );
  }
}