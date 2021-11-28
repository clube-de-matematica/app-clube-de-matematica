import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'shared/repositories/supabase/auth_supabase_repository.dart';

/// URL do projeto do Supabase.
///
/// TODO: NÃO CONSEGUI CORRIGIR O ERRO DE CERTIFICADO USANDO `https`.
const _kSupabaseUrl = 'https://dlhhqapgjuyvzxktohck.supabase.co';

/// Anon key do projeto do Supabase.
const _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyODYxNjA5OSwiZXhwIjoxOTQ0MTkyMDk5fQ.fdCHd5Bx4fBNyo3ENvQF1cb0X0FnucGTepe5SSRL7Q0';

/// Scheme da URL (ou URI) de redirecionamento do projeto do Supabase.
const kAuthCallbackUrlScheme = 'com.sslourenco.clubedematematica';

/// Host da URL (ou URI) de redirecionamento do projeto do Supabase.
const kAuthCallbackUrlHostname = 'login-callback';

/// URL (ou URI) de redirecionamento do projeto do Supabase.
const _kAuthRedirectUri = '$kAuthCallbackUrlScheme://$kAuthCallbackUrlHostname';

/// Retorna a URL (ou URI) de redirecionamento do projeto do Supabase.
/// Para a web, retorna `null`.
String? get authRedirectUri {
  if (kIsWeb) {
    return null;
  } else {
    return _kAuthRedirectUri;
  }
}

/// Iniciar e retornar o [Supabase] singleton.
Future<Supabase> initializeSupabase() async {
  return Supabase.initialize(
    url: _kSupabaseUrl,
    anonKey: _kSupabaseAnonKey,
    authCallbackUrlHostname: kAuthCallbackUrlHostname,
    debug: true,
    // Para a Web usará o hive (padrão).
    localStorage: kIsWeb ? null : SecureLocalStorage(),
  )
    // Durante Supabase.initialize, se houver uma sessão de usuário persistente ela é retomada.
    ..then((supabase) {
      if (supabase.client.auth.currentUser != null)
        AuthSupabaseRepository.setUserApp();
    });
}

/// Usar o `flutter_secure_storage` para persistir a sessão do usuário com segurança.
class SecureLocalStorage extends LocalStorage {
  SecureLocalStorage()
      : super(
          initialize: () async {},
          hasAccessToken: () {
            const storage = FlutterSecureStorage();
            return storage.containsKey(key: supabasePersistSessionKey);
          },
          accessToken: () {
            const storage = FlutterSecureStorage();
            return storage.read(key: supabasePersistSessionKey);
          },
          removePersistedSession: () {
            const storage = FlutterSecureStorage();
            return storage.delete(key: supabasePersistSessionKey);
          },
          persistSession: (String value) {
            const storage = FlutterSecureStorage();
            return storage.write(key: supabasePersistSessionKey, value: value);
          },
        );
}
