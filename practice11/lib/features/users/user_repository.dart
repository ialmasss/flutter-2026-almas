import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  const UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    final decoded = await _api.get('/users');
    try {
      final list = decoded as List<dynamic>;
      return list
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    final decoded = await _api.get('/users/$id');
    try {
      return User.fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    final decoded = await _api.post(
      '/users',
      body: draft.toJson(),
      expectedStatus: 201,
    );
    try {
      return User.fromJson(decoded as Map<String, dynamic>);
    } catch (e) {
      throw BadResponseException('POST users: $e');
    }
  }
}