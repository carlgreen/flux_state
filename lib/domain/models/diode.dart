class Diode {
  Diode({required this.code});

  final String code;
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
    return '$code: $count';
  }
}
