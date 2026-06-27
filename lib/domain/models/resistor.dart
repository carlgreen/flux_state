class Resistor {
  Resistor({
    required this.value,
    required this.tolerance,
    required this.power,
    this.count = 0,
  });

  final String value;
  final String tolerance;
  final String power;
  int count;

  void add() {
    count++;
  }

  void remove() {
    count--;

    if (count < 0) {
      count = 0;
    }
  }

  String display() {
    return '$value $power ($tolerance)';
  }

  @override
  String toString() {
    return '$value $power ($tolerance): $count';
  }
}
