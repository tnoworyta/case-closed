require 'rails_helper'

RSpec.describe LessonForm do
  describe '#valid?' do
    context 'lesson params valid' do
      it 'returns true' do
        create(:tutor, email: 'tutor@example.com')

        expect(LessonForm.new(Lesson.new, {
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-01',
          hour: '12:00'
        }).valid?).to be true
      end
    end

    context 'lesson date invalid' do
      it 'returns false' do
        create(:tutor, email: 'tutor@example.com')

        lesson_form = LessonForm.new(Lesson.new, {
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '20190501',
          hour: '12:00'
        })
        expect(lesson_form.valid?).to be false
        expect(lesson_form.errors[:date]).to include('is invalid')
      end
    end

    context 'lesson hour invalid' do
      it 'returns false' do
        create(:tutor, email: 'tutor@example.com')

        lesson_form = LessonForm.new(Lesson.new, {
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-01',
          hour: '1200'
        })

        expect(lesson_form.valid?).to be false
        expect(lesson_form.errors[:hour]).to include('is invalid')
      end
    end

    context 'lesson tutor email not found' do
      it 'returns false' do
        lesson_form = LessonForm.new(Lesson.new, {
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-01',
          hour: '1200'
        })

        expect(lesson_form.valid?).to be false
        expect(lesson_form.errors[:tutor_email]).to include('is invalid')
      end
    end
  end
end
