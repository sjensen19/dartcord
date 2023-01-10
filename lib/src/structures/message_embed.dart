import 'message_embed_text_field.dart';
import 'message_embed_author.dart';
import 'message_embed_footer.dart';

/// Represents a discord embed that can be used inside a [Message]
class MessageEmbed {
  final String? title;
  final String? description;
  final String? url;

  /// [color] represents a hex color
  ///
  /// Format: 0xHEXCODE (e.g. 0xff0000 would be red)
  final int? color;
  final MessageEmbedAuthor? author;
  final MessageEmbedFooter? footer;
  final List<MessageEmbedTextField>? fields;

  MessageEmbed({
    this.title,
    this.description,
    this.color,
    this.url,
    this.fields,
    this.author,
    this.footer,
  });
}
