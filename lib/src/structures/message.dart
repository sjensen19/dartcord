import 'dart:convert';

import 'package:http/http.dart' as http;

import '../util/config.dart' as config;
import '../util/constants.dart' as constants;
import '../util/helpers/message_embed.dart';

import 'text_channel.dart';
import 'message_embed.dart';
import 'user.dart';

/// Represents any Discord message in a [TextChannel]
class Message {
  final String id;
  final TextChannel channel;
  final User? author;
  final String content;

  Message({
    required this.id,
    required this.channel,
    required this.author,
    required this.content,
  });

  /// Sends a reply to a [Message]
  ///
  /// At least a [message] or one [MessageEmbed] in [embeds] must be provided!
  Future<void> reply([String? message, List<MessageEmbed>? embeds]) async {
    Map<String, dynamic> messageObject = {
      "content": message,
      "message_reference": {
        "message_id": id,
        "channel_id": channel.id,
        "guild_id": channel.guild?.id,
        "fail_if_not_exists": false,
      },
      "embeds": null
    };

    if (embeds != null) {
      messageObject["embeds"] = generateDiscordEmbedsObject(embeds);
    }

    http.Response response = await http.post(
      Uri.parse("${constants.apiBaseURL}/channels/${channel.id}/messages"),
      headers: {
        "Authorization": "Bot ${config.botToken}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(messageObject),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to send message. ($message)");
    }
  }
}
