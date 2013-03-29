class QuestionLike
  attr_reader :id, :question, :user
  def initialize(id, question, user)
    @id, @question, @user = id, question, user
  end
end