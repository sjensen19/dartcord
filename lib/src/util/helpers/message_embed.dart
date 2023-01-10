import '../../structures/message_embed.dart';
import '../../structures/message_embed_author.dart';
import '../../structures/message_embed_footer.dart';
import '../../structures/message_embed_text_field.dart';

List<Map<String, dynamic>> generateDiscordEmbedsObject(
    List<MessageEmbed> embeds) {
  List<Map<String, dynamic>> embedsObjects = [];
  for (MessageEmbed embed in embeds) {
    Map<String, dynamic> embedObject = {
      "title": embed.title,
      "description": embed.description,
      "url": embed.url,
      "color": embed.color,
      "fields": null,
      "author": null,
      "footer": null
    };

    List<Map<String, dynamic>> fieldObjects = [];
    for (MessageEmbedTextField field in embed.fields ?? []) {
      fieldObjects.add({
        "name": field.name,
        "value": field.value,
        "inline": field.inline,
      });
    }
    if (fieldObjects.isNotEmpty) embedObject["fields"] = fieldObjects;

    MessageEmbedFooter? footer;
    if (footer != null) {
      embedObject["footer"] = {
        "text": footer.text,
        "icon_url": footer.iconURL,
      };
    }
    MessageEmbedAuthor? author;
    if (author != null) {
      embedObject["author"] = {
        "name": author.name,
        "url": author.url,
        "icon_url": author.iconURL,
      };
    }

    embedsObjects.add(embedObject);
  }

  return embedsObjects;
}
