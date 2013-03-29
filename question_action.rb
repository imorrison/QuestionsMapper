class QuestionAction
  attr_reader :id, :type, :question, :time
  def initialize(options = {})
    @id = options['id']
    @type = options['type']
    @question = options['questions_id']
    @time = options['time_stamp'] 
  end
end