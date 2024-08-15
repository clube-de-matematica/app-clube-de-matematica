import 'package:clubedematematica/app/shared/models/debug.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'shared/models/exceptions/clube_error.dart';
import 'shared/repositories/supabase/auth_supabase_repository.dart';

/// URL do projeto do Supabase.
const _kSupabaseUrl = 'https://dlhhqapgjuyvzxktohck.supabase.co';

/// Anon key do projeto do Supabase.
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODYxNjA5OSwiZXhwIjoxOTQ0MTkyMDk5fQ.fdCHd5Bx4fBNyo3ENvQF1cb0X0FnucGTepe5SSRL7Q0';

/// Scheme da URL (ou URI) de redirecionamento do projeto do Supabase.
const kAuthCallbackUrlScheme = 'com.sslourenco.clubedematematica';

/// Iniciar e retornar o [Supabase] singleton.
Future<Supabase> initializeSupabase() async {
  return Supabase.initialize(
    url: _kSupabaseUrl,
    anonKey: _kSupabaseAnonKey,
    debug: Debug.inDebugger,
    authOptions: FlutterAuthClientOptions(
      autoRefreshToken: true,
      // Para a Web usará o hive (padrão).
      localStorage: kIsWeb ? null : SecureLocalStorage(),
    ),
  )
    // Durante Supabase.initialize, se houver uma sessão de usuário persistente ela é retomada.
    ..then((supabase) {
      if (supabase.client.auth.currentUser != null) {
        AuthSupabaseRepository.setUserApp();
      }
    });
}

/// Usar o `flutter_secure_storage` para persistir a sessão do usuário com segurança.
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage();
  final _storage = const FlutterSecureStorage();

  final _opcoesAndroid = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  /// Usado para tratar erros.
  Future<void> _deleteAll() async {
    try {
      return await _storage.deleteAll(aOptions: _opcoesAndroid);
    } on PlatformException catch (e, stack) {
      ClubeError.reportFlutterError(
        ClubeError.getDetails(e, stack, library: 'configure_supabase.dart'),
      );
      return;
    }
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() async {
    try {
      return await _storage.read(
        key: supabasePersistSessionKey,
        aOptions: _opcoesAndroid,
      );
    } on PlatformException catch (_) {
      await _deleteAll();
      return null;
    }
  }

  @override
  Future<bool> hasAccessToken() async {
    try {
      return await _storage.containsKey(
        key: supabasePersistSessionKey,
        aOptions: _opcoesAndroid,
      );
    } on PlatformException catch (_) {
      await _deleteAll();
      return false;
    }
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    try {
      return await _storage.write(
        key: supabasePersistSessionKey,
        value: persistSessionString,
        aOptions: _opcoesAndroid,
      );
    } on PlatformException catch (_) {
      await _deleteAll();
      return;
    }
  }

  @override
  Future<void> removePersistedSession() async {
    try {
      return await _storage.delete(
        key: supabasePersistSessionKey,
        aOptions: _opcoesAndroid,
      );
    } on PlatformException catch (_) {
      await _deleteAll();
      return;
    }
  }
}
