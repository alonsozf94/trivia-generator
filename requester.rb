require "httparty"
require "json"

module Requester
  include HTTParty
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    options = ["random", "scores", "exit"]
    action = ""
    loop do
      puts options.join(" | ")
      print "> "
      action = gets.chomp
      break if options.include?(action)
      puts "Invalid option"
    end
    action
  end

  def ask_question(question)
    # show category and difficulty from question
    # show the question
    # show each one of the options
    # grab user input
  end

  def will_save?(score)
    # show user's score
    # ask the user to save the score
    # grab user input
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
  end

  def gets_option(prompt, options = [], extra = true)
    input = ""
    loop do
      puts "#{prompt}: " if extra
      print "> "
      input = gets.chomp
      break unless input.empty? || !options.include?(input)

      puts "Invalid option"
    end
    input.empty? ? nil : input
  end

  def gets_input(prompt)
    input = ""
    loop do
      puts "#{prompt}"
      print "> "
      input = gets.chomp
      break unless input.empty?

      puts "This can't be blank"
    end
    input.empty? ? nil : input
  end
end