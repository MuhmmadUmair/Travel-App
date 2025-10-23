import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Size size;
  const HeaderSection({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/bk.jpg',
          width: double.infinity,
          height: size.height / 3.2,
          fit: BoxFit.cover,
        ),
        Positioned(
          left: 20,
          top: 64,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Travelers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato',
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Explore beautiful destinations',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
