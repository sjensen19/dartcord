/// Represents a TextField inside a [MessageEmbed] instance
class MessageEmbedTextField {
  final String name;
  final String value;
  final bool inline;

  MessageEmbedTextField(
      {required this.name, required this.value, this.inline = false});
}
