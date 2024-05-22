
enum Priority { low, moderate, high }

class PriorityDistance {
  final Priority priority;
  late final double distance;

  PriorityDistance({required this.priority, required this.distance});
}
