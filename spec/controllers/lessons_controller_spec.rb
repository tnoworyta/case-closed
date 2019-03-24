require 'rails_helper'

RSpec.describe 'LessonsController', type: :request do
  describe 'POST create' do
    context 'all lesson data valid' do
      it 'lesson created' do
        create(:student, email: 'student@example.com')
        create(:tutor, email: 'tutor@example.com')
        expect(CreateLesson).to receive(:call).and_call_original

        post '/lessons', params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'tutor@example.com',
            date: '2019-05-08',
            hour: '12:00'
          }
        }

        expect(response).to have_http_status(202)
      end
    end

    context 'malformed date' do
      it 'lesson not created' do
        expect(CreateLesson).to receive(:call).and_call_original

        post '/lessons', params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'tutor@example.com',
            date: '20190508',
            hour: '12:00'
          }
        }

        expect(response).to have_http_status(400)
      end
    end

    context 'malformed time' do
      it 'lesson not created' do
        expect(CreateLesson).to receive(:call).and_call_original

        post '/lessons', params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'tutor@example.com',
            date: '2019-05-08',
            hour: '12--00'
          }
        }

        expect(response).to have_http_status(400)
      end
    end
  end
end
