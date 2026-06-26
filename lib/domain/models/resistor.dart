class Resistor {
  Resistor({required this.value, required this.tolerance, required this.power});

  final String value;
  final String tolerance;
  final String power;
  int count = 0;

  void add() {
    count++;
  }

  void remove() {
    count--;

    if (count < 0) {
      count = 0;
    }
  }

  @override
  String toString() {
    return '$value $power ($tolerance): $count';
  }
}
