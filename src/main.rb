require 'yaml'
require 'telegram/bot'

API_KEY = ''
TARGET_CHAT_ID = # т.к. я его заточил под один чат

yaml_file = File.open("db.yaml")
Messages = YAML.load(yaml_file.read)
puts "Loaded #{Messages.size} messages"

Telegram::Bot::Client.run(API_KEY) do |bot|
  bot.listen do |message|
    if message.methods.include?(:text) && message.chat.id == TARGET_CHAT_ID
      Messages.append(message.text)
      puts "(#{Messages.size}) Appended #{message.text}"

      case message.text
      when "Сколько сообщений"
          bot.api.send_message(chat_id: message.chat.id, text: "Я знаю #{Messages.size} сообщений")
      end

      if rand(0..5) == 1 and message.chat.id
        bot.api.send_message(chat_id: message.chat.id, text: Messages.sample)
        File.write("db.yaml", Messages.to_yaml) # вынесено т.к. с большой базой сообщений так можно ускорить принятие сообщений
        puts "Sent new random message and saved db"
      end
    end
  end
end
