require_relative "questionsdb"
require_relative 'question'
require_relative 'reply'

class User
  def self.find(id)
    query = <<-SQL
    SELECT *
    FROM users
    WHERE id = ? ;
    SQL

    User.new(QuestionsDB.instance.execute(query, id).first)
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT *
    FROM users
    WHERE users.fname = ? AND users.lname = ?;
    SQL

    users = QuestionsDB.instance.execute(query, fname, lname).map do |user|
      User.new(user)
    end

    users.length > 1 ? users : users.first
  end

  attr_accessor :fname, :lname, :is_instructor
  attr_reader :id
  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
    @is_instructor = options['is_instructor']
  end

  def create
    if id.nil?
      query = <<-SQL
      INSERT INTO users ('fname', 'lname', 'is_instructor')
      VALUES (?, ?, ?)
      SQL
      QuestionsDB.instance.execute(query, fname, lname, is_instructor)
      @id = QuestionsDB.instance.last_insert_row_id
    else
      update
    end
  end

  def update
    query = <<-SQL
      UPDATE users
      SET fname = ?, lname = ?, is_instructor = ?
      WHERE id = ?
      SQL
    QuestionsDB.instance.execute(query, fname, lname, is_instructor, id)
  end

  def questions
    Question.find_by_author(id)
  end
  
  # followed questions

  def replies
    Reply.find_by_author(id)
  end

  def average_karma
    query = <<-SQL
    SELECT COUNT(question_likes.id) / COUNT(questions.id) avg
    FROM question_likes JOIN questions
    ON (question_likes.question_id = questions.id )
    WHERE questions.author_id = ?
    SQL

    QuestionsDB.instance.execute(query, id)
  end

  def most_karma(n)
    query = <<-SQL
    SELECT questions.id
    FROM questions JOIN question_likes
    ON (questions.id = question_likes.question_id)
    WHERE author_id = ?
    GROUP BY question_id
    ORDER BY COUNT(question_likes.question_id) DESC
    LIMIT ?
    SQL

    QuestionsDB.instance.execute(query, id, n).map do |question|
      Question.find(question['id'])
    end
  end
end













