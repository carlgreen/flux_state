class Diode {
  Diode({required this.code, this.count = 0});

  final String code;
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
    return code;
  }

  @override
  String toString() {
    return '$code: $count';
  }
}
