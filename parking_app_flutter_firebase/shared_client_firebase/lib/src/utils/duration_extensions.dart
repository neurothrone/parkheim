extension DurationExtensions on Duration {
  String get formatted {
    final hours = inHours;
    final minutes = (inMinutes % 60).toString().padLeft(2, "0");
    final seconds = (inSeconds % 60).toString().padLeft(2, "0");
    return "$hours:$minutes:$seconds";
  }
}
