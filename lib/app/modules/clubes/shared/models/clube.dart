import 'dart:convert';

class Clube {
  final int id;
  final String nome;
  final int proprietario;
  final List<int> administradores;
  final List<int> membros;
  Clube({
    required this.id,
    required this.nome,
    required this.proprietario,
    this.administradores = const [],
    this.membros = const [],
  });

  factory Clube.fromMap(Map<String, dynamic> map) {
    return Clube(
      id: map['id'],
      nome: map['nome'],
      proprietario: map['proprietario'],
      administradores: List<int>.from(map['administradores']),
      membros: List<int>.from(map['membros']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'proprietario': proprietario,
      'administradores': administradores,
      'membros': membros,
    };
  }

  factory Clube.fromJson(String source) => Clube.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
