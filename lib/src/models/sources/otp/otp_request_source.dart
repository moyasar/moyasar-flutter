class OtpRequestSource {
  final String otpValue;

  OtpRequestSource({required this.otpValue});

  factory OtpRequestSource.fromJson(Map<String, dynamic> json) {
    return OtpRequestSource(
      otpValue: json['otp_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'otp_value': otpValue,
    };
  }
}
