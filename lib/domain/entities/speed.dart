enum Speed { slow, medium, fast }

extension SpeedValueExtension on Speed {
  int get value {
    switch (this) {
      case Speed.slow:
        return 30;
      case Speed.medium:
        return 20;
      case Speed.fast:
        return 5;
    }
  }
}

extension SpeedNameExtension on Speed {
  String get name {
    switch (this) {
      case Speed.slow:
        return 'Slow';
      case Speed.medium:
        return 'Medium';
      case Speed.fast:
        return 'Fast';
    }
  }
}
