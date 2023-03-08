
class Distance {
  final int totalDistance;

  const Distance({
    required this.totalDistance,
  });

  factory Distance.fromMap(Map<String, dynamic> map) {
    final data = Map<String, dynamic>.from(map['rows'][0]);

    int distance = 0;

    if ((data['elements'] as List).isNotEmpty) {
      final elementos = data['elements'][0];
      distance = elementos['distance']['value'];
    }

    return Distance(
      totalDistance: distance,
    );
  }
}
