import 'TypeOfCard.dart';

class Card {
  final int personId;
  final String cardCode;
  final TypeOfCard typeOfCard;

  Card({
    required this.personId,
    required this.cardCode,
    required this.typeOfCard,
  });

  Map<String, dynamic> toJson() => {
    'personId': personId,
    'cardCode': cardCode,
    'typeOfCard': typeOfCard.name,
  };

  static Card fromJson(Map<String, dynamic> json) => Card(
    personId: json['personId'] as int,
    cardCode: json['cardCode'] as String,
    typeOfCard: TypeOfCard.values.byName(json['typeOfCard'] as String),
  );

  @override
  String toString() => 'Card(personId=$personId, cardCode=$cardCode, typeOfCard=$typeOfCard)';
}
