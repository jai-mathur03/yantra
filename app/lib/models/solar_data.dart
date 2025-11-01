class SolarData {
  final List<List<double>> data;
  final String message;
  final bool status;

  SolarData({
    required this.data,
    required this.message,
    required this.status,
  });

  factory SolarData.fromJson(Map<String, dynamic> json) {
    return SolarData(
      data: (json['data'] as List)
          .map((innerList) => (innerList as List)
              .map((item) => (item is double)
                  ? item.toDouble()
                  : item as double) // ✅ Convert double to 
              .toList())
          .toList(),
      message: json['message'],
      status: json['status'],
    );
  }
}
