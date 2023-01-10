import 'dart:convert';
import 'package:http/http.dart' as http;

import '../util/config.dart' as config;
import '../util/constants.dart' as constants;
import '../util/helpers/message_embed.dart';

import 'channel.dart';
import 'guild.dart';

import 'message_embed.dart';

/// Represents a Discord TextChannel
class TextChannel extends Channel {
  final String topic;

  TextChannel(String id, String name, Guild guild, int channelType, this.topic)
      : super(id: id, name: name, guild: guild, type: channelType);

  /// Send a message to the [TextChannel] instance
  ///
  /// At least a [message] or one [MessageEmbed] in [embeds] must be provided!
  Future<void> sendMessage(
      [String? message, List<MessageEmbed>? embeds]) async {
    Map<String, dynamic> messageObject = {
      "content": message,
      "embeds": null,
    };

    if (embeds != null) {
      messageObject["embeds"] = generateDiscordEmbedsObject(embeds);
    }

    http.Response response = await http.post(
      Uri.parse("${constants.apiBaseURL}/channels/$id/messages"),
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
