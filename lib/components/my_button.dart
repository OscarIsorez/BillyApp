import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.text});

  final String text; 

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return 
    
    GestureDetector(
      onTap: onTap,
  
      child: 
      Container(
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        padding: const EdgeInsets.all(25.0),
        margin : const EdgeInsets.symmetric(horizontal: 25),
        child: 
         Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          
          ),
        ),

      ),
    );

  }
}