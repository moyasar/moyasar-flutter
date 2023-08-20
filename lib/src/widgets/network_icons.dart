import 'package:flutter/material.dart';

class NetworkIcons extends StatelessWidget {
  const NetworkIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        NetworkIcon(name: 'assets/images/visa.png'),
        NetworkIcon(name: 'assets/images/mada.png'),
        NetworkIcon(name: 'assets/images/mastercard.png'),
        NetworkIcon(name: 'assets/images/amex.png'),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class NetworkIcon extends StatelessWidget {
  const NetworkIcon({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name,
      height: 20,
      width: 35,
      package: 'moyasar',
    );
  }
}
