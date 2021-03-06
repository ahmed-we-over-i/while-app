import 'package:while_app/presentation/screens/timer/misc/constants.dart';

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

double calculateCircleDrop(double height, double controllerValue) {
  return (-1 * ((height / 2))) + (((circleRadius * 2) + spaceBetweenDots) * controllerValue);
}

double calculateLoadedCirclePosition(double height, int secondsRemaining) {
  return (-1 * ((height / 2) - ((circleRadius * 2) + spaceBetweenDots)) * (secondsRemaining / 60));
}
