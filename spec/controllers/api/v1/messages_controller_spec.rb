require 'spec_helper'
require "rails_helper"
require "./spec/complicated_message_context.rb"

describe Api::V1::MessagesController do
  describe '#parse' do
    let(:api_call) { post :parse, params, nil }

    context "when there is no 'message' in the request body" do
      let(:params) { { foo: 'hello' } }

      before { api_call }

      it 'has a status of 400 with an error' do
        expect(response.status).to eq 400
        response_body = JSON.parse(response.body)
        expected_body = {'error' => 'message param must be present.'}
        expect(response_body).to eq expected_body
      end
    end

    context 'when the message has no mention, emoticon, or url' do
      let(:params) { { message: 'the best conference ever (ihavebeengoingtheresinceapril2013' } }
      let(:response_body) { JSON.parse(response.body) }

      before { api_call }

      it 'has a status of 200 with an empty hash as the repsonse body' do
        expect(response.status).to eq 200
        expect(response.body).to be
        expect(response_body).to eq ({})
      end
    end

    context 'when the message string contains 2 mentions, 2 emoticons, and 2 urls', :complicated_message do
      let(:params) { { message: msg_str } }
      let(:response_body) { JSON.parse(response.body) }

      before { api_call }

      it 'has a status of 200 with a response body' do
        expect(response.status).to eq 200
        expect(response.body).to be
      end

      it 'has a response body in Hash with 3 Array elements of size 2' do
        expect(response_body).to be_an_instance_of(Hash)
        expect(response_body.size).to eq 3
        response_body.each do |_, v|
          expect(v).to be_an_instance_of(Array)
          expect(v.size).to eq 2
        end
      end

      it 'has the 2 mentions and 2 emoticons in the response body' do
        expect(response_body['mentions']).to eq both_mentions
        expect(response_body['emoticons']).to eq both_emoticons
      end

      it 'has the 2 links from the 2 urls in the response body' do
        links = response_body['links']
        expect(links).to be
        first_link = links.first
        expect(first_link['url']).to eq url_1
        expect(first_link.include?('title')).to be false

        last_link = links.last
        expect(last_link['url']).to eq url_2
        expect(last_link['title']).to eq title_2
      end
    end
  end
end
