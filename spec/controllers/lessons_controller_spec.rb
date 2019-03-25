require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  describe 'POST /lessons' do
    context 'lesson data valid' do
      it 'accepts lesson' do
        create(:tutor, email: 'tutor@example.com')
        expect(WhatADayWrapper).to receive(:timeslot_available?)
        expect(CreateLesson).to receive(:call).with({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-01',
          hour: '12:00'
        }).and_call_original

        post :create, params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'tutor@example.com',
            date: '2019-05-01',
            hour: '12:00'
          }
        }
        expect(response.status).to eq(202)
      end
    end

    context 'lesson date invalid' do
      it 'rejects lesson' do
        create(:tutor, email: 'tutor@example.com')
        expect(CreateLesson).to receive(:call).with({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '20190501',
          hour: '12:00'
        }).and_call_original

        post :create, params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'tutor@example.com',
            date: '20190501',
            hour: '12:00'
          }
        }
        expect(response.status).to eq(400)
      end
    end

    context 'lesson tutor not found' do
      it 'rejects lesson' do
        expect(CreateLesson).to receive(:call).with({
          student_email: 'student@example.com',
          tutor_email: 'tutor@example.com',
          date: '2019-05-01',
          hour: '12:00'
        }).and_call_original

        post :create, params: {
          lesson: {
            student_email: 'student@example.com',
            tutor_email: 'tutor@example.com',
            date: '2019-05-01',
            hour: '12:00'
          }
        }
        expect(response.status).to eq(404)
      end
    end
  end
end
