require 'spec_helper'
require "rails_helper"
require "./spec/complicated_message_context.rb"

describe Message do
  describe '#initialize' do
    shared_examples_for 'a message without a mention, emoticon, or link' do
      it_behaves_like "an object with a 'msg_str' attribute"

      it 'has no mentions, emoticons, or links' do
        expect(subject.mentions).to be_empty
        expect(subject.emoticons).to be_empty
        expect(subject.links).to be_empty
      end
    end

    shared_examples_for "an object with a 'msg_str' attribute" do
      it "has a 'msg_str' attribute that is the string passed in" do
        expect(subject.msg_str).to eq msg_str
      end
    end

    subject { described_class.new(msg_str) }

    context 'when the message string is nil' do
      let(:msg_str) { nil }

      it 'raise an Argument error' do
        expect{ subject }.to raise_error(ArgumentError, 'Message cannot be blank')
      end
    end

    context 'when the message string is a blank string' do
      let(:msg_str) { '' }
      it_behaves_like 'a message without a mention, emoticon, or link'
    end

    context 'when the message string has no mention, emoticon, or url' do
      let(:msg_str) { 'anyone around?' }
      it_behaves_like 'a message without a mention, emoticon, or link'
    end

    context 'when the message string only contains mentions' do
      let(:msg_str) { " @#{mention_1} @#{mention_2} you around?" }
      let(:mention_1) { 'chris' }
      let(:mention_2) { 'john' }

      it_behaves_like "an object with a 'msg_str' attribute"

      it 'has 2 mentions, but no emoticons or links' do
        expect(subject.mentions).to eq [mention_1, mention_2]
        expect(subject.emoticons).to be_empty
        expect(subject.links).to be_empty
      end
    end

    context 'when the message string only contains emoticons' do
      let(:msg_str) { "Good morning! (#{emoticon_1}) (#{emoticon_2})" }
      let(:emoticon_1) { 'megusta' }
      let(:emoticon_2) { 'coffee' }

      it_behaves_like "an object with a 'msg_str' attribute"

      it 'has 2 emoticons, but no mentions or links' do
        expect(subject.mentions).to be_empty
        expect(subject.emoticons).to eq [emoticon_1, emoticon_2]
        expect(subject.links).to be_empty
      end
    end

    context 'when the message string only contains a url' do
      let(:msg_str) { "Olympics are starting soon; #{url}" }
      let(:url) { 'http://www.nbcolympics.com' }
      let(:title) { '2016 Rio Olympic Games | NBC Olympics' }

      before { stub_get_request(url, title) }

      it_behaves_like "an object with a 'msg_str' attribute"

      it 'has no mentions or emoticons' do
        expect(subject.mentions).to be_empty
        expect(subject.emoticons).to be_empty
      end

      it 'has a link' do
        links = subject.links
        expect(links).to be
        expect(links.size).to eq 1
        link = links.first
        expect_link(link, url)
        expect(link.title).to eq title
      end
    end

    context 'when the message string contains 2 mentions, 2 emoticons, and 2 urls', :complicated_message do
      it_behaves_like "an object with a 'msg_str' attribute"

      it 'has the 2 mentions and the 2 emoticons' do
        expect(subject.mentions).to eq both_mentions
        expect(subject.emoticons).to eq both_emoticons
      end

      it 'has 2 links from the two urls' do
        links = subject.links
        expect(links).to be
        expect(links.size).to eq 2
        both_urls.zip(links) { |url, link| expect_link(link, url)}
        expect(links.first.title).to be_nil
        expect(links.last.title).to eq title_2
      end
    end

    def expect_link(link, url)
      expect(link).to be_an_instance_of(Link)
      expect(link.url).to eq url
    end

    def stub_get_request(url, title)
      stub_request(:get, url).to_return(status: 200, body: "foo<title>#{title}</title>bar")
    end
  end
end
