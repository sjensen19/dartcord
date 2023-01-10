import 'dart:convert';
import 'package:http/http.dart' as http;

import '../util/config.dart' as config;
import '../util/constants.dart' as constants;

import 'user.dart';

/// Represents a Discord guild/server
class Guild {
  final String id;
  final String name;
  final User owner;

  Guild({
    required this.id,
    required this.name,
    required this.owner,
  });

  /// Retrieves a Discord Guild from an [id]
  static Future<Guild> fromID(String id) async {
    http.Response response = await http
        .get(Uri.parse("${constants.apiBaseURL}/guilds/$id"), headers: {
      "Authorization": "Bot ${config.botToken}",
      "Content-Type": "application/json",
    });
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch the channel with the ID $id.");
    }
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    User guildOwner = await User.fromID(decodedResponse["owner_id"]);

    return Guild(
      id: decodedResponse["id"],
      name: decodedResponse["name"],
      owner: guildOwner,
    );
  }
}
