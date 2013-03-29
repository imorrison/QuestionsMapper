require_relative "migration"

class Reply
  def self.find(id)
    query = <<-SQL
    SELECT *
    FROM replies
    WHERE id = ?;
    SQL

    Reply.new(QuestionsDB.instance.execute(query, id).first)
  end

  def self.most_replied
    query = <<-SQL
    SELECT a.*
    FROM replies a JOIN replies b ON (a.id = b.parent_id)
    GROUP BY b.parent_id
    ORDER BY COUNT(b.parent_id) DESC
    LIMIT 1
    SQL

    Reply.new(QuestionsDB.instance.execute(query).first)
  end

  attr_reader :id, :question_id, :parent_id, :body, :author_id
  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @body = options['body']
    @author_id = options['author_id']
  end

  def replies
    query = <<-SQL
    SELECT *
    FROM replies
    WHERE parent_id = ?
    SQL
    QuestionsDB.instance.execute(query, id).map do |reply|
      Reply.new(reply)
    end
  end
end