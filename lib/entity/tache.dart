import 'package:jesuisauthiste/entity/comp.dart';

class Tache {
  final String id;
  final String tache;
  final String objectif;
  final String question;
  final String exemples;
  final String observations;
  final int active;
  final int nbcritieres;
  final Competence competence;

  Tache(
      {required this.id,
      required this.tache,
      required this.objectif,
      required this.question,
      required this.exemples,
      required this.observations,
      required this.active,
      required this.nbcritieres,
      required this.competence});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tache': tache,
      'objectif': objectif,
      'question': question,
      'exemples': exemples,
      'observations': observations,
      'active': active,
      'nbcritieres': nbcritieres,
      'competence': competence,
    };
  }
}
