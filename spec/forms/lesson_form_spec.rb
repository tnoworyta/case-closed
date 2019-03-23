require 'rails_helper'

RSpec.describe 'LessonForm' do
  describe '#save' do
    context 'when saving lesson with valid params' do
      it 'creates new lesson' do
        student = create(:student, email: 'student@example.com')
        tutor = create(:tutor, email: 'tutor@example.com')
        lesson = Lesson.new
        LessonForm.new(lesson, {
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-08',
          hour: '12:00'
        }).save

        expect(lesson.reload).to have_attributes(
          student: student,
          tutor: tutor,
          datetime: Time.parse('2019-05-08 12:00 +00:00')
        )
      end
    end
  end

  describe '#valid?' do
    context 'when date has improper format' do
      it 'is not valid' do
        lesson_form = LessonForm.new(Lesson.new, {
          student_email: 'student@example.com',
          tutor_email: 'student@example.com',
          date: '20190508',
          hour: '12:00'
        })
        expect(lesson_form.valid?).to be false
        expect(lesson_form.errors[:date]).to include('is invalid')
      end
    end

    context 'when time has improper format' do
      it 'is not valid' do
        lesson_form = LessonForm.new(Lesson.new, {
          student_email: 'student@example.com',
          tutor_email: 'student@example.com',
          date: '2019-05-08',
          hour: '12--00'
        })
        expect(lesson_form.valid?).to be false
        expect(lesson_form.errors[:hour]).to include('is invalid')
      end
    end
  end
end
