class Type {
  final int id;
  final String type;

  Type({required this.id, required this.type});
  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type};
  }
}
