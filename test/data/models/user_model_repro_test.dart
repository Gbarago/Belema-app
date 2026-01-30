import 'package:flutter_test/flutter_test.dart';
import 'package:belema_fin_app/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test(
      'should return a valid model when the JSON ID is an integer',
      () async {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': 123,
          'username': 'testuser',
          'token': 'some_token',
        };

        // Act
        final result = UserModel.fromJson(jsonMap);

        // Assert
        expect(result, isA<UserModel>());
        expect(result.id, '123');
      },
    );
  });
}
