import 'package:flutter/material.dart';
import 'package:moyasar/src/models/payment_config.dart';

/// The widget that shows the Credit Cards icons.
class NetworkIcons extends StatelessWidget {
  final PaymentConfig config;

  const NetworkIcons({super.key, required this.config});

  /// Maps PaymentNetwork enum to their corresponding image assets
  static final Map<PaymentNetwork, String> _networkImages = {
    PaymentNetwork.visa: 'assets/images/visa.png',
    PaymentNetwork.mada: 'assets/images/mada.png',
    PaymentNetwork.masterCard: 'assets/images/mastercard.png',
    PaymentNetwork.amex: 'assets/images/amex.png',
  };

  /// Maps custom network names to their corresponding image assets
  /// Add your custom network images here
  static const Map<String, String> _customNetworkImages = {
    // Example: 'custom_network': 'assets/images/custom_network.png',
  };

  @override
  Widget build(BuildContext context) {
    // Get enum-based network images
    final supportedNetworkImages = config.supportedNetworks
        .where((network) => _networkImages.containsKey(network))
        .map((network) => _networkImages[network]!)
        .toList();

    // Add custom network images if provided
    final customNetworkImages = config.customNetworks
        ?.where((network) => _customNetworkImages.containsKey(network))
        .map((network) => _customNetworkImages[network]!)
        .toList() ?? [];

    final allNetworkImages = [...supportedNetworkImages, ...customNetworkImages];

    if (allNetworkImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...allNetworkImages.map((imagePath) => NetworkIcon(name: imagePath)),
        const SizedBox(
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
