import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
  });

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(6)
        ),
        child: Center(child: Text('CONTINUE',style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),)),
      ),
    );
  }
}
