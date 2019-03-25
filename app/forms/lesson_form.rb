class LessonForm < Patterns::Form
  attribute :student_email, String
  attribute :tutor_email, String
  attribute :date, String
  attribute :hour, String

  validates :student_email, :tutor_email, :date, :hour, presence: true
  validates :date, format: { with: /\d{4}-\d{2}-\d{2}/ }
  validates :hour, format: { with: /\d{2}:\d{2}/ }
  validate :valid_tutor_email

  private

  def valid_tutor_email
    unless Tutor.find_by(email: tutor_email)
      errors.add(:tutor_email, :invalid)
    end
  end
end
