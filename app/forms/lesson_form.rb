class LessonForm < Patterns::Form
  param_key "lesson"

  attribute :student_email, String
  attribute :tutor_email, String
  attribute :date, String
  attribute :hour, String

  validates :student_email, :tutor_email, presence: true
  validates :date, format: { with: /\d{4}-\d{2}-\d{2}/ }
  validates :hour, format: { with: /\d{2}:\d{2}/ }

  def persist
    resource.update(attributes.except(:date, :hour).merge(datetime: "#{date} #{hour}".to_datetime))
  end
end
