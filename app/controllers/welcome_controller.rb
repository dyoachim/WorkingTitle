class WelcomeController < ApplicationController

  def index
    @books = Book.all
    @recent_books = Book.order(created_at: :desc).limit(5)
    @recent_comments = Comment.order(created_at: :desc).limit(5)
    @best_level = Book.get_highest_level_book
    @most_words = Book.get_most_words_book
    @best_word_length = Book.get_highest_word_length_book
    @best_syllable_length = Book.get_most_syllable_book
    @best_sentence_length = Book.get_longest_sentences_book
    @most_author = Book.group(:author).count.first
    @most_book = Book.group(:title).count.first
  end
end
