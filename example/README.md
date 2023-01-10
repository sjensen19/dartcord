# Dartcord examples
> **⚠️ PLEASE NOTE**
> 
> More examples are coming soon

## Hello command
```dart
import 'package:dartcord_core/dartcord_core.dart';

const String token = "token";

void onMessage(Message message) async {
  if (message.author.isBot) return;

  if (message.content == "!hello") {
    return await message.reply("Hello!");
  }
}

void main() async {
  Client c = Client();

  c.onReady((User user) {
    print("${user.username} is online!");
  });
  c.onMessage(onMessage);

  c.login(token);
}
```

## MessageEmbed example
```dart
import 'package:dartcord_core/dartcord_core.dart';

const String token = "token";

void onMessage(Message message) async {
  if (message.author.isBot) return;

  MessageEmbed embed = MessageEmbed(
    author: MessageEmbedAuthor.fromUser(message.author),
    color: 0xa2e66e, // Color code in hex fomat
    description: "A simple example of an MessageEmbed",
    title: "Example Embed",
    fields: [
      MessageEmbedTextField(name: "User", value: message.author.username),
      MessageEmbedTextField(
          name: "Guild name", value: message.channel.guild!.name),
    ],
  );

  if (message.content == "!embed") {
    return await message.reply(null, [embed]);
  }
}

void main() async {
  Client c = Client();

  c.onReady((User user) {
    print("${user.username} is online!");
  });
  c.onMessage(onMessage);

  c.login(token);
}
```