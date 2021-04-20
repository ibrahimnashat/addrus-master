import 'dart:convert';

class StateData {
   int id;
   int minutes;
   int score;
   int wrong;
   int right;
   String status;



  StateData({
    this.id,
    this.minutes,
    this.score,
    this.wrong,
    this.right,
    this.status,

  });

  static StateData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return StateData(
        id: json['id'],
        minutes: json['minutes'],
        score: json['score'],
        wrong: json['wrong'],
        right: json['right'],
        status: json['status'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'minutes': minutes,
        'score': score,
        'wrong': wrong,
        'right': right,
        'status': status,
      };

    String encodedJson() => json.encode(toJson());

   static StateData decodedJson(String source) =>
       fromJson(json.decode(source));


}

