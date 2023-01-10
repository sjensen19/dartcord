/// Represents the different Channel Types in discord
class ChannelType {
  /// Represents a [TextChannel] inside a guild/server
  static int get guildText => 0;

  /// Represents a [TextChannel] inside a direct message
  static int get dm => 1;
  static int get guildVoice => 2;
  static int get groupDm => 3;
  static int get guildCategory => 4;
  static int get guildAnnouncement => 5;
  static int get announcementThread => 10;
  static int get publicThread => 11;
  static int get privateThread => 12;
  static int get guildStageVoice => 13;
  static int get guildDirectory => 14;
  static int get guildForum => 15;
}
