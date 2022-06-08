import 'constants.dart';

int calculateCirclesAboveLine(double scrollOffset) {
  int temp = ((scrollOffset) / ((2 * circleRadius) + spaceBetweenDots)).floor();

  if (temp > maxTime) return maxTime;

  return temp;
}

double calculateActualOffset(int circlesAboveLine) {
  double temp = (((2 * circleRadius) + spaceBetweenDots) * circlesAboveLine).toDouble();

  if (temp <= 0) return 0;

  return temp;
}
