# Dartcord
Dartcord makes it easy to create discord bots using the Dart programming language

> **⚠️ PLEASE NOTE**
> 
> This project is in a really early stage. This means anything is subject to change without prior notice!

## Contents
- [Dartcord](#dartcord)
  - [Contents](#contents)
  - [Features](#features)
    - [What about slash commands?](#what-about-slash-commands)
  - [Getting started](#getting-started)
    - [Add dartcord to your project](#add-dartcord-to-your-project)
    - [Create a discord bot application](#create-a-discord-bot-application)
  - [Usage](#usage)
    - [Simple hello command](#simple-hello-command)
  - [Additional information](#additional-information)

## Features
* Sending messages to a specific channel (supports embeds)
* Replying to messages (supports embeds)
* Getting users
* Getting information about a guild (server)
* Mentioning users and channels
### What about slash commands?
Slash command creation support will be added using the package `dartcord_interactions` when available. This package will then include different builders to create slash commands. 

> **NOTE**: This package is not required when trying to recieve slash command events.

## Getting started
### Add dartcord to your project
Use pub to add dartcord to your project
```bash
dart pub add dartcord_core
dart pub get
```
or add dartcord to your `pubspec.yaml` yourself
```yml
dependencies:
  dartcord_core: ^0.3.0
```
### Create a discord bot application
To create a discord bot application, follow the following steps:
1. Go to the [discord developer portal](https://discord.com/developers/applications) and login using your discord account
2. In the top right corner of the page, click `New Application`.
    * Give your application a name in the popup
    * Agree to the [discord terms of service](https://discord.com/developers/docs/policies-and-agreements/developer-terms-of-service) and the [discord developer policy](https://discord.com/developers/docs/policies-and-agreements/developer-policy) and click on `create`
3. Go into the `Bot` submenu and click on `Add bot`. Then click `Yes, do it!`
4. Now you've created your bot! Scroll down on this page and check all options under `Privileged Gateway Intents`. (**NOTE**: This will change in the future depending on the gateway intents you will actually need.)
5. Go into OAuth2 > URL Generator
    * Under `scopes`, click bot
    * Then, under `Bot Permissions`, click Administrator, or all permissions you are going to use
    * Invite your bot to your server using the link on the bottom of the page
6. Go back into `Bot` and click the `Reset token` button
    * Click `Yes, do it!` and copy the token.
    * Use this token in the `Client.login("token")` method.

Now your bot is fully set-up for discord! Go into your favorite IDE and create your first discord bot using dartcord!

## Usage
### Simple hello command
```dart
import 'package:dartcord_core/dartcord_core.dart';

const String token = "token";

void onMessage(Message message) async {
    if(message.author.isBot) return;

    if(message.content == "!hello") {
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

## Additional information
> Currently, there is no way to contribute to the dartcord project. Keep an eye out for updates for more information about becoming a contributor to the project. Documentation on a website is also coming as soon as possible.

Currently, issues can be filed by sending an e-mail to the author, [Sven Jensen](mailto:sven.jensen@cbdevelopment.nl)