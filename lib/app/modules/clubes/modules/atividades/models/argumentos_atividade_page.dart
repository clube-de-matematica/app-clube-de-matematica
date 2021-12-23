import '../../../shared/models/clube.dart';
import '../pages/consolidar/consolidar_atividade_page.dart';
import '../pages/responder/reponder_atividade_page.dart';
import 'atividade.dart';

/// Modelo para os argumentos do construtor de [ConsolidarAtividadePage] e 
/// [ResponderAtividadePage].
class ArgumentosAtividadePage {
  final Atividade atividade;
  final Clube clube;
  const ArgumentosAtividadePage({
    required this.atividade,
    required this.clube,
  });
}