import 'dart:convert';
import 'package:http/http.dart' as http;

import '../util/config.dart' as config;
import '../util/constants.dart' as constants;

import 'guild.dart';
import 'channel_type.dart';
import 'text_channel.dart';

/// Represents a discord Channel
///
/// Extension for [TextChannel]
abstract class Channel {
  final String id;
  final String? name;
  final Guild? guild;
  final int type;

  Channel({
    required this.id,
    required this.name,
    required this.type,
    required this.guild,
  });

  /// Returns a mention string to mention a [Channel]
  String mention() {
    return "<#$id>";
  }

  /// Retrieves a [Channel] of any type using the channel [id]
  ///
  /// Returns a [TextChannel] if the type is not defined
  static Future<Channel> fromID(String id) async {
    http.Response response = await http
        .get(Uri.parse("${constants.apiBaseURL}/channels/$id"), headers: {
      "Authorization": "Bot ${config.botToken}",
      "Content-Type": "application/json",
    });
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch the channel with the ID $id.");
    }
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    int type = int.tryParse(decodedResponse["type"].toString()) ??
        ChannelType.guildText;

    Guild parentGuild = await Guild.fromID(decodedResponse["guild_id"] ?? "");
    switch (type) {
      case 0: // guildText
        return TextChannel(decodedResponse["id"], decodedResponse["name"],
            parentGuild, 0, decodedResponse["topic"]);
      default:
        return TextChannel(decodedResponse["id"], decodedResponse["name"],
            parentGuild, 0, decodedResponse["topic"]);
    }
  }
}
