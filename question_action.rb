class QuestionAction
  attr_reader :type, :question, :time
  def initialize(type, question, time)
    @type, @question, @time = type, question, time
  end
end