import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'util/constants.dart' as constants;
import 'util/config.dart' as config;

import 'structures/user.dart';
import 'structures/message.dart';
import 'structures/channel.dart';
import 'structures/text_channel.dart';
import 'structures/guild.dart';
import 'structures/channel_type.dart';

/// Represents a Discord Client, usually a bot user
class Client {
  late IOWebSocketChannel _channel;

  // Fill in callbacks
  void Function(User user)? _onReady;

  void Function(Message message)? _onMessage;
  void Function(Message message)? _onMessageUpdate;
  void Function(Message message)? _onMessageDelete;

  void Function(Channel channel)? _onChannelCreate;
  void Function(Channel channel)? _onChannelUpdate;
  void Function(Channel channel)? _onChannelDelete;

  /// [callback] will be called when the `READY` event has been recieved.
  void onReady(Function(User user) callback) => _onReady = callback;

  /// [callback] will be called when the `MESSAGE_CREATE` event has been recieved
  void onMessage(Function(Message message) callback) => _onMessage = callback;

  /// [callback] will be called when the `MESSAGE_UPDATE` event has been recieved
  void onMessageUpdate(Function(Message message) callback) =>
      _onMessageUpdate = callback;

  /// [callback] will be called when the `MESSAGE_DELETE` event has been recieved
  void onMessageDelete(Function(Message message) callback) =>
      _onMessageDelete = callback;

  /// [callback] will be called when the `CHANNEL_CREATE` event has been recieved
  void onChannelCreate(Function(Channel channel) callback) =>
      _onChannelCreate = callback;

  /// [callback] will be called when the `CHANNEL_UPDATE` event has been recieved
  void onChannelUpdate(Function(Channel channel) callback) =>
      _onChannelUpdate = callback;

  /// [callback] will be called when the `CHANNEL_DELETE` event has been recieved
  void onChannelDelete(Function(Channel channel) callback) =>
      _onChannelDelete = callback;

  /// When [apiVersion] is specified, the api will use a different version
  Client([int apiVersion = 10]) {
    config.apiVersion = apiVersion;
    _channel = IOWebSocketChannel.connect(constants.gateWayURL);
  }

  void _handleEvent(String type, Map<String, dynamic> decodedMessage) async {
    switch (type) {
      case "READY":
        if (_onReady == null) return;
        _onReady!(User(
          id: decodedMessage["d"]["user"]["id"],
          username: decodedMessage["d"]["user"]["username"],
          discriminator: decodedMessage["d"]["user"]["discriminator"],
          isBot: decodedMessage["d"]["user"]["bot"],
        ));
        break;
      case "CHANNEL_CREATE":
        if (_onChannelCreate == null) return;
        // TODO: Handle creation of other types of channels instead of only [TextChannel]
        int channelType = decodedMessage["d"]["type"];
        if (channelType != ChannelType.guildText) return;
        _onChannelCreate!(TextChannel(
            decodedMessage["d"]["id"],
            decodedMessage["d"]["name"],
            await Guild.fromID(decodedMessage["d"]["guild_id"]),
            decodedMessage["d"]["type"],
            decodedMessage["d"]["topic"]));
        break;
      case "CHANNEL_UPDATE":
        if (_onChannelUpdate == null) return;
        // TODO: Handle creation of other types of channels instead of only [TextChannel]
        int channelType = decodedMessage["d"]["type"];
        if (channelType != ChannelType.guildText) return;
        _onChannelUpdate!(TextChannel(
            decodedMessage["d"]["id"],
            decodedMessage["d"]["name"],
            await Guild.fromID(decodedMessage["d"]["guild_id"]),
            decodedMessage["d"]["type"],
            decodedMessage["d"]["topic"]));
        break;
      case "CHANNEL_DELETE":
        if (_onChannelDelete == null) return;
        // TODO: Handle creation of other types of channels instead of only [TextChannel]
        int channelType = decodedMessage["d"]["type"];
        if (channelType != ChannelType.guildText) return;
        _onChannelDelete!(TextChannel(
            decodedMessage["d"]["id"],
            decodedMessage["d"]["name"],
            await Guild.fromID(decodedMessage["d"]["guild_id"]),
            decodedMessage["d"]["type"],
            decodedMessage["d"]["topic"]));
        break;
      case "MESSAGE_DELETE":
        if (_onMessageDelete == null) return;
        TextChannel channel =
            await Channel.fromID(decodedMessage["d"]["channel_id"])
                as TextChannel;
        _onMessageDelete!(Message(
          author: null,
          channel: channel,
          content: "",
          id: decodedMessage["d"]["id"],
        ));
        break;
      case "MESSAGE_UPDATE":
        // TODO: Implement mentions field
        if (_onMessageUpdate == null) return;
        TextChannel channel =
            await Channel.fromID(decodedMessage["d"]["channel_id"])
                as TextChannel;

        User author = await User.fromID(decodedMessage["d"]["author"]["id"]);
        _onMessageUpdate!(Message(
          id: decodedMessage["d"]["id"],
          content: decodedMessage["d"]["content"],
          channel: channel,
          author: author,
        ));
        break;
      case "MESSAGE_CREATE":
        // TODO: Implement mentions field
        if (_onMessage == null) return;
        TextChannel channel =
            await Channel.fromID(decodedMessage["d"]["channel_id"])
                as TextChannel;

        User author = await User.fromID(decodedMessage["d"]["author"]["id"]);
        _onMessage!(Message(
          id: decodedMessage["d"]["id"],
          content: decodedMessage["d"]["content"],
          channel: channel,
          author: author,
        ));
        break;
    }
  }

  /// Authenticates the [Client] at the discord gateway and listens for any event
  void login(String token) async {
    _setToken(token);

    // TODO: Pass through discord gateway intent code instead of setting a default
    const int intents = 3276799;

    _channel.stream.listen(
      (var msg) {
        Map<String, dynamic> decodedMessage = jsonDecode(msg);

        int opCode = decodedMessage["op"];
        switch (opCode) {
          case 0:
            String type = decodedMessage["t"].toString();
            _handleEvent(type, decodedMessage);
            break;
          case 10:
            int heartbeatInterval = decodedMessage["d"]["heartbeat_interval"];

            // Send a heartbeat to the gateway every [heartbeatInterval]
            // milliseconds to keep the connection alive
            Timer.periodic(Duration(milliseconds: heartbeatInterval),
                (Timer timer) {
              _channel.sink.add(jsonEncode({
                "op": 1,
                "d": null,
              }));
            });

            // Authenticate the user to the discord API
            Map<String, dynamic> authenticationMessage = {
              "op": 2,
              "d": {
                "token": config.botToken,
                "intents": intents,
                "properties": {
                  "\$os": Platform.operatingSystem,
                  "\$browser": "dartcord",
                  "\$device": "dartcord"
                },
                "presence": {"status": "online", "activities": [], "afk": false}
              }
            };

            _channel.sink.add(jsonEncode(authenticationMessage));
            break;
        }
      },
      onDone: () {},
      onError: (var err) {
        // TODO: Handle errors
        print("[CLIENT] ERROR: $err");
      },
      cancelOnError: true,
    );
  }

  /// Closes the discord gateway websocket
  void quit() {
    _channel.sink.close(status.goingAway);
  }

  void _setToken(String token) {
    config.botToken = token;
  }
}
