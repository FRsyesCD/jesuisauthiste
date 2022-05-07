class Competence {
  final String id;
  final String competence;
  final int nbtaches;
  final Type type;

  Competence(
      {required this.id,
      required this.competence,
      required this.nbtaches,
      required this.type});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'competence': competence,
      'nbtaches': nbtaches,
      'type': type,
    };
  }
}
