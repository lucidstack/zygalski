Zygalski - A Slack cryptographic utility for extremely secret agents
========

## Warning: This is (at the moment) a toy project, made for fun and to talk about Mr Robot in our Slack channels. Avoid using this tool to plan your next revolution.

Zygalski is a little server that replies to Slack slash commands for private/public key encription of messages.

The server responds to three routes/slash commands:
* `POST /new-key`: creates/overwrites a private/public key pair for the channel where the command is issued from. The slash command should have a `/new-key [passphrase]` signature.
* `POST /encrypt`: encrypts and returns a given message, using the public key of the channel (the `channel_name` query param sent from Slack is used). The slash command should have a `/encrypt [message]` signature.
* `POST /decrypt`: decrypts and returns a given encrypted message, using the private key of the channel and the passphrase in the slash command text. The slash command should have a `/encrypt "[passphrase]" [message]` signature.

## Installation
1. Make sure you have `openssl` in your `PATH`
2. [Install Elixir](http://elixir-lang.org/install.html)
3. In the project root, run `mix deps.get`

## Running it
Start with `elixir --no-halt -S mix`. Releases with `exrm` on the way.
