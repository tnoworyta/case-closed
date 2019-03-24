class CreateLesson < Patterns::Service
  def initialize(lesson_params)
    @lesson_params = lesson_params
    @errors = []
  end

  def call
    validate_lesson_params
    enqueue_availability_check
  end

  attr_reader :errors

  private

  def validate_lesson_params
    lesson_form = LessonForm.new(lesson_params)
    lesson_form.valid?
    self.errors = lesson_form.errors
  end

  def enqueue_availability_check
    return if errors.any?
    CheckAvailabilityAndCreateLessonJob.perform_later(
      date: lesson_params[:date],
      time: lesson_params[:hour],
      student_id: Student.find_by(email: lesson_params[:student_email]).id,
      tutor_id: Tutor.find_by(email: lesson_params[:tutor_email]).id
    )
  end

  attr_reader :lesson_params
  attr_writer :errors
end
