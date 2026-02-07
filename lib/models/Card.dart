import 'TypeOfCard.dart';
class Card {
  final int personId;
  final TypeOfCard typeOfCard;

  Card({required this.personId, required this.typeOfCard});

  @override
  String toString() => 'Card(personId=$personId, typeOfCard=$typeOfCard)';
}