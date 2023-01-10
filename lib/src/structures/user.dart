import 'dart:convert';

import 'package:http/http.dart' as http;

import '../util/config.dart' as config;
import '../util/constants.dart' as constants;

/// Represents a Discord User
class User {
  final String id;
  final String username;
  final String discriminator;
  final bool isBot;

  User({
    required this.id,
    required this.username,
    required this.discriminator,
    required this.isBot,
  });

  /// Returns a mention string to mention a [User]
  String mention() {
    return "<@$id>";
  }

  /// Retrieves a Discord User from an [id]
  static Future<User> fromID(String id) async {
    http.Response response = await http
        .get(Uri.parse("${constants.apiBaseURL}/users/$id"), headers: {
      "Authorization": "Bot ${config.botToken}",
      "Content-Type": "application/json",
    });
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch the user with the ID $id.");
    }
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    return User(
      id: decodedResponse["id"],
      username: decodedResponse["username"],
      discriminator: decodedResponse["discriminator"],
      isBot: decodedResponse["bot"] ?? false,
    );
  }
}
