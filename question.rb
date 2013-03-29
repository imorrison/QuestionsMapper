require_relative "migration"
require_relative "reply"

class Question
  def self.find(id)
    query = <<-SQL
    SELECT *
    FROM questions
    WHERE id = ? ;
    SQL

    Question.new(QuestionsDB.instance.execute(query, id).first)
  end

  def self.find_by_title(title)
    query = <<-SQL
    SELECT *
    FROM questions
    WHERE title LIKE ?;
    SQL

    questions = QuestionsDB.instance.execute(query, "%#{title}%").map do |question|
      Question.new(question)
    end
    questions.length > 1 ? questions : questions.first
  end

  def self.questions_by_author(author)
    # not yet implemented 
  end

  def self.most_liked(n)
    query = <<-SQL
    SELECT questions.id, title, body, author_id
    FROM questions JOIN question_likes
    ON (questions.id = question_likes.question_id)
    GROUP BY question_id
    ORDER BY COUNT(question_likes.question_id) DESC
    LIMIT ?
    SQL

    QuestionsDB.instance.execute(query, n).map do |question|
      Question.new(question)
    end
  end

  def self.most_followed(n)
    query = <<-SQL
    SELECT questions.id, title, body, author_id
    FROM questions JOIN question_followers
    ON (questions.id = question_followers.question_id)
    GROUP BY question_id
    ORDER BY COUNT(question_followers.question_id) DESC
    LIMIT ?
    SQL

    QuestionsDB.instance.execute(query, n).map do |question|
      Question.new(question)
    end
  end

  attr_accessor :title, :body, :author
  attr_reader :id

  def initialize(options = {})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author = options['author_id']
  end

  def create
    if id.nil?
      query = <<-SQL
        INSERT INTO questions ('title', 'body', 'author_id')
        VALUES (?, ?, ?)
      SQL
      QuestionsDB.instance.execute(query, title, body, author)
      @id = QuestionsDB.instance.last_inserted_row_id
    else
      update
    end
  end

  def update
    query = <<-SQL
      UPDATE questions
      SET  title = ?, body = ?, author_id = ?
      WHERE id = ?
    SQL
    QuestionsDB.instance.execute(query, title, body, author_id)
  end

  def num_likes
    query = <<-SQL
    SELECT COUNT(*)
    FROM questions JOIN question_likes ON (questions.id = question_id)
    WHERE question_likes.question_id = ?
    GROUP BY question_likes.question_id
    SQL

    QuestionsDB.instance.execute(query, id).first.values.first
  end

  def followers
    query = <<-SQL
    SELECT question_followers.user_id
    FROM question_followers JOIN questions
    ON (question_followers.question_id = questions.id )
    WHERE question_followers.question_id = ?
    SQL

    QuestionsDB.instance.execute(query, id).map do |follower|
      User.find(follower['user_id'])
    end
  end

  def most_replies(n)
    query = <<-SQL
    SELECT a.*
    FROM replies a JOIN replies b ON (a.id = b.parent_id)
    WHERE a.question_id = ?
    GROUP BY b.parent_id
    ORDER BY COUNT(b.parent_id) DESC
    LIMIT ?
    SQL

    QuestionsDB.instance.execute(query, id, n).map do |reply|
      Reply.new(reply)
    end
  end
end









