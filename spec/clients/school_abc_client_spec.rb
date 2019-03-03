require 'spec_helper'

RSpec.describe 'SchoolAbcClient', type: :client do
  describe '#student' do
    context 'valid pincode' do
      it 'student data returned' do
        expect(ENV).to receive(:fetch).with('API_TOKEN') { 'token1' }

        stub_request(:get, 'www.example.com/student?pincode=1234').with(headers: { "Authorization" => "Bearer token1" })
          .to_return(body: {data: { student: { id: "586f7275d01dd3040033e6eb", name: 'John Doe' } }}.to_json, status: 200)

        expect(SchoolAbcClient.new.student(pincode: '1234')).to eq({data: { student: { id: "586f7275d01dd3040033e6eb", name: 'John Doe' } }})
      end
    end

    context 'invalid pincode' do
      it 'empty data returned' do
        expect(ENV).to receive(:fetch).with('API_TOKEN') { 'token1' }

        stub_request(:get, 'www.example.com/student?pincode=1234').with(headers: { "Authorization" => "Bearer token1" })
          .to_return(status: 404)

          expect(SchoolAbcClient.new.student(pincode: '1234')).to eq({})
      end
    end
  end

  describe '#booking' do

  end
end
