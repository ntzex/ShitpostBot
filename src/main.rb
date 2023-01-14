require 'yaml'
require 'telegram/bot'

API_KEY = ''
TARGET_CHAT_ID = # т.к. я его заточил под один чат

yaml_file = File.open("db.yaml")

Messages = YAML.load(yaml_file.read)

Telegram::Bot::Client.run(API_KEY) do |bot|
  bot.listen do |message|
    if message.text != nil
      Messages.append(message.text)
      File.write("db.yaml", Messages.to_yaml)
      if rand(0..5) == 1 and message.chat.id == TARGET_CHAT_ID
        bot.api.send_message(chat_id: message.chat.id, text: Messages.sample)
      end
      case message.text
      when 'сколько сообщений'
        bot.api.send_message(chat_id: message.chat.id, text: Messages.size)
      end
    end
  end
end
