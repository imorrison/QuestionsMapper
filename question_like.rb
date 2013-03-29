class QuestionLike
  attr_reader :id, :question, :user
  def initialize(opitons = {})
    @id = options['id']
    @question = options['question_id']
    @user = options['user_id']
  end
end