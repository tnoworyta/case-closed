class CreateLesson < Patterns::Service
  def initialize(lesson_params)
    @lesson_params = lesson_params
    @errors = []
  end

  def call
    validate_lesson_data
    check_calendar_availability
  end

  attr_reader :errors

  private

  def validate_lesson_data
    lesson_form = LessonForm.new(Lesson.new, lesson_params)
    lesson_form.valid?
    self.errors = lesson_form.errors
  end

  def check_calendar_availability
    return if errors.any?
    CheckAvailabilityAndCreateLessonJob.perform_later(
      student_email: lesson_params[:student_email],
      tutor_id: Tutor.find_by(email: lesson_params[:tutor_email]).id,
      date: lesson_params[:date],
      hour: lesson_params[:hour]
    )
  end

  attr_reader :lesson_params
  attr_writer :errors
end
