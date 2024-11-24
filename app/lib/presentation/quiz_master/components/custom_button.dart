import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      width: MediaQuery.of(context).size.width / 4.5,
      height: MediaQuery.of(context).size.width / 4.5,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width / 10,
                ),
              ),
              if (text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
