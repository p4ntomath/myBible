import 'dart:math';

String getRandomImage(){
  final random = Random();
  int randomNumber = random.nextInt(7) + 1;
  return "assets/pic$randomNumber.jpg";
}