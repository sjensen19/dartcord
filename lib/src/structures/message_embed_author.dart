import 'user.dart';

/// Represents the author field inside a [MessageEmbed] instance
class MessageEmbedAuthor {
  final String name;
  final String? url;
  final String? iconURL;

  MessageEmbedAuthor({required this.name, this.url, this.iconURL});

  /// Creates a [MessageEmbedAuthor] field from a [User]
  factory MessageEmbedAuthor.fromUser(User user) {
    return MessageEmbedAuthor(name: user.username);
  }
}
