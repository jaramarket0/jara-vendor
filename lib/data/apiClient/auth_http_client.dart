import 'dart:convert';

import 'package:http/http.dart' as http;

/// Wraps [http.Client] so that any authenticated request (one carrying an
/// `Authorization: Bearer` header) which comes back `401` — meaning the
/// backend rejected it as an expired/invalid token, as "User not found", or
/// because the account was signed in on another device (see
/// api/utils.py::api_exception_handler and
/// apps/accounts/authentication.py on the Django side, all of which return
/// 401) — invokes [onUnauthenticated] so the app can clear the local session
/// and route back to the login screen. Requests without an Authorization
/// header (login, register, OTP, forgot-password, ...) are left untouched so
/// their own screens can surface the real error.
///
/// The server's machine-readable `code` is passed along, because being signed
/// out for being on a second phone needs a different explanation from a
/// session that simply expired — one is a rule, the other is routine.
class AuthHttpClient extends http.BaseClient {
  AuthHttpClient({required this.onUnauthenticated, http.Client? inner})
      : _inner = inner ?? http.Client();

  final http.Client _inner;
  final Future<void> Function(String? code) onUnauthenticated;
  static bool _handlingExpiry = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);

    if (response.statusCode != 401 ||
        !request.headers.containsKey('Authorization')) {
      return response;
    }

    // A response body is a single-subscription stream: reading it here would
    // leave the caller with an empty body. So buffer it, read the code, and
    // hand back an identical response rebuilt from those bytes.
    final bytes = await response.stream.toBytes();
    String? code;
    try {
      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is Map && decoded['code'] is String) {
        code = decoded['code'] as String;
      }
    } catch (_) {
      // A 401 with a non-JSON body is still a 401; the reason is just unknown.
    }

    _handleExpiredSession(code);

    return http.StreamedResponse(
      Stream.value(bytes),
      response.statusCode,
      contentLength: bytes.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  void _handleExpiredSession(String? code) {
    if (_handlingExpiry) return;
    _handlingExpiry = true;
    onUnauthenticated(code).whenComplete(() => _handlingExpiry = false);
  }
}
