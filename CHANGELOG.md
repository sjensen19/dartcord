## 0.3.1
- Changed `User.bot` to `User.isBot` to comply with the [effective dart](https://dart.dev/guides/language/effective-dart/design#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable) style guidelines
- Updated the `README`, preparing for the next update (dartcord_core v0.4.0 and dartcord_interactions v0.1.0), which includes support for interactions.

## 0.3.0
- Added name property to `Channel`
- Added topic property to `TextChannel`
- Added callbacks on `Client` for the `MESSAGE_DELETE` and `MESSAGE_UPDATE` events
- Added callbacks on `Client` for the `CHANNEL_CREATE`, `CHANNEL_UPDATE` and `CHANNEL_DELETE` events
- Made `Message.author` nullable

## 0.2.1
- Added inline property to `MessageEmbedTextField`

## 0.2.0
- Added MessageEmbed support (This works in both `Message.reply()` and `TextChannel.sendMessage()`)
- Added a helper method to mention a specific user or channel (`User.mention()` and `TextChannel.mention()`)

## 0.1.1
- Added dartdoc comments to the public API
- Added an example, with more examples coming soon

## 0.1.0
Added the following features to the codebase
- Sending messages to a specific channel
- Replying to messages
- Getting users
- Getting information about a guild (server)