import 'package:jesuisauthiste/entity/tache.dart';

class Critere {
  final Tache tache;
  final String critere;
  final int score;

  Critere({required this.tache, required this.critere, required this.score});
  Map<String, dynamic> toMap() {
    return {'tache': tache, 'critere': critere, 'score': score};
  }
}
