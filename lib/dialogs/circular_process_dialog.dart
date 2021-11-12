import 'package:flutter/material.dart';

class CircularProcessDialog extends StatelessWidget {
  const CircularProcessDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
