require 'rails_helper'

RSpec.describe 'LessonsController', type: :request do
  describe 'POST create' do
    context 'all lesson data valid' do
      it 'lesson created' do
        expect_any_instance_of(LessonForm).to receive(:save).and_call_original

        post '/lessons', params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'student@example.com',
            date: '2019-05-08',
            hour: '12:00'
          }
        }

        expect(response).to have_http_status(200)
      end
    end

    context 'malformed date' do
      it 'lesson not created' do
        expect_any_instance_of(LessonForm).to receive(:save).and_call_original

        post '/lessons', params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'student@example.com',
            date: '20190508',
            hour: '12:00'
          }
        }

        expect(response).to have_http_status(400)
      end
    end

    context 'malformed time' do
      it 'lesson not created' do
        expect_any_instance_of(LessonForm).to receive(:save).and_call_original

        post '/lessons', params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'student@example.com',
            date: '2019-05-08',
            hour: '12--00'
          }
        }

        expect(response).to have_http_status(400)
      end
    end
  end
end
