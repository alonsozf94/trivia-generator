# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "terminal-table"
require "httparty"
require "json"
require 'htmlentities'
require_relative "presenter"
require_relative "requester"

class CliviaGenerator
  # maybe we need to include a couple of modules?
  include Presenter
  include Requester

  def initialize
    # we need to initialize a couple of properties here
    @question_array = []
    @score_registration = {name: "", score: 0}
    @filename = 'scores.json'
  end

  def start
    # welcome message
    # prompt the user for an action
    # keep going until the user types exit
    print_welcome
    action = ""
    until action == "exit"
      action = select_main_menu_action
      case action
      when "random" then random_trivia
      when "scores"
        puts print_scores
        print_welcome
      when "exit" then puts "Good bye!"
      end
    end
  end

  def random_trivia
    # Asks each question
    load_questions
    ask_questions(@question_array)
    puts "Well done! Your score is #{@score_registration[:score]}"
    puts "--------------------------------------------------"
    save_option = gets_option("Do you want to save your score? (y/n)", ["y","n"])
    save(@score_registration) if save_option == "y"
    print_welcome
  end

  def ask_questions(questions)
    # Iterates each question
    questions.each do |question|
      puts decode_strings("Category: #{question[:category]} | Difficulty: #{question[:difficulty].capitalize}")
      puts decode_strings("Question: #{question[:question]}")

      # Creates array of all options
      answer_options = (question[:incorrect_answers] << question[:correct_answer]).shuffle

      # Iterates options
      answer_options.each_with_index do |option, index|
        puts decode_strings("#{index + 1}. #{option}")
      end

      # Waits for input and checks answer
      answer = gets_option("", ["1","2","3","4"], false) if answer_options.length == 4
      answer = gets_option("", ["1","2"], false) if answer_options.length == 2
      if answer_options[answer.to_i - 1] == question[:correct_answer]
        @score_registration[:score] += 10
        puts "Correct answer!"
      else
        puts "#{answer_options[answer.to_i - 1]}... Incorrect!"
        puts "Te correct answer was #{question[:correct_answer]}"
      end
    end
  end

  def save(data)
    # write to file the scores data
    player_name = gets_input("Type the name to asign to the score")
    @score_registration[:name] = player_name
    if File.file?(@filename)
      File.write(@filename, []) if File.zero?(@filename)
      scores = JSON.parse(File.read(@filename))
      scores << @score_registration
      File.write(@filename, scores.to_json)
    else
      File.open(@filename, "w") do |file|
        file.write([@score_registration].to_json)
      end
    end
  end

  def load_questions
    # Requests for trivia questions and stores data
    response = HTTParty.get("https://opentdb.com/api.php?amount=10")
    raise(HTTParty::ResponseError, response) unless response.success?
    @question_array = JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def decode_strings(string)
    # questions came with an unexpected structure, clean them to make it usable for our purposes
    coder = HTMLEntities.new
    new_string = coder.decode(string)
  end

  def print_scores
    # Get information from file
    if File.file?(@filename)
      sorted_table = JSON.parse(File.read(@filename)).sort_by { |item| -item["score"]}
    else
      sorted_table = []
    end

    # Print the scores sorted from top to bottom
    table = Terminal::Table.new
    table.title = "Top Scores"
    table.headings = ["Name", "Score"]
    table.rows = sorted_table.map do |item|
      [item["name"], item["score"]]
    end
    table
  end
end

trivia = CliviaGenerator.new
trivia.start
