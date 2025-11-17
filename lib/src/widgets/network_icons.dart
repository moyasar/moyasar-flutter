import 'package:flutter/material.dart';
import 'package:moyasar/src/models/payment_config.dart';

/// The widget that shows the Credit Cards icons.

class NetworkIcons extends StatelessWidget {
  final PaymentConfig config;
  final TextDirection textDirection;

  const NetworkIcons({
    super.key,
    required this.config,
    required this.textDirection
  });

  /// Maps PaymentNetwork enum to their corresponding image assets
  static final Map<PaymentNetwork, String> _networkImages = {
    PaymentNetwork.visa: 'assets/images/visa.png',
    PaymentNetwork.mada: 'assets/images/mada.png',
    PaymentNetwork.masterCard: 'assets/images/mastercard.png',
    PaymentNetwork.amex: 'assets/images/amex.png',
  };

  @override
  Widget build(BuildContext context) {
    // Get enum-based network images
    final supportedNetworkImages = config.supportedNetworks
        .where((network) => _networkImages.containsKey(network))
        .map((network) => _networkImages[network]!)
        .toList();

    final allNetworkImages = [...supportedNetworkImages];

    if (supportedNetworkImages.isEmpty) {
      return const SizedBox.shrink();
    }

    final isRTL = textDirection == TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Row(
        mainAxisAlignment: isRTL ? MainAxisAlignment.start : MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        textDirection: textDirection,
        children: [
          ...allNetworkImages.map((imagePath) =>
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: NetworkIcon(name: imagePath),
              )
          ),
          const SizedBox(width: 5),
        ],
      ),
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
      height: 18,
      width: 26,
      package: 'moyasar',
      fit: BoxFit.contain, // 🆕 إضافة fit
    );
  }
}