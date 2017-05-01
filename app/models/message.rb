class Message
  alias :read_attribute_for_serialization :send

  MENTION_IDENTIFIER = '@'
  EMOTICON_BEGIN_WITH = '('
  EMOTICON_END_WITH = ')'
  MAX_EMOTICON_LENGTH = 15
  WEB_URL_IDENTIFIER_1 = 'http://'
  WEB_URL_IDENTIFIER_2 = 'https://'

  attr_reader :msg_str, :mentions, :emoticons, :links

  def initialize(str)
    raise ArgumentError.new('Message cannot be blank') if str.nil?
    @msg_str = str
    @mentions = []
    @emoticons = []
    @links = []
    parse
  end

  private

  def parse
    i = 0
    while i < msg_str.size do
      c = msg_str[i]
      if c == MENTION_IDENTIFIER
        i = grab_mention(i+1)
      elsif c == EMOTICON_BEGIN_WITH
        i = grab_emoticon(i+1)
      elsif possible_url?(i)
        i = construct_links(i)
      else
        i += 1
      end
    end
  end

  def grab_mention(idx)
    i = idx
    c = msg_str[i]
    while i< msg_str.size && letter?(c) do
      i += 1
      c = msg_str[i]
    end
    mention = msg_str[idx..i-1]
    mentions << mention if mention
    i
  end

  def grab_emoticon(idx)
    i = idx
    c = msg_str[i]
    while i< msg_str.size && (i-idx)<=MAX_EMOTICON_LENGTH do
      break if c == EMOTICON_END_WITH || !alphanumeric?(c)
      i += 1
      c = msg_str[i]
    end
    if c == EMOTICON_END_WITH
      emoticon = msg_str[idx..i-1]
      emoticons << emoticon if emoticon
    end
    i
  end

  def possible_url?(i)
    sub_str = msg_str[i..-1].downcase
    [WEB_URL_IDENTIFIER_1, WEB_URL_IDENTIFIER_2].any? {|e| sub_str.start_with?(e) }
  end

  def construct_links(i)
    idx = i
    distance = msg_str[i..-1].downcase.start_with?(WEB_URL_IDENTIFIER_1) ?
        WEB_URL_IDENTIFIER_1.size : WEB_URL_IDENTIFIER_2.size
    i += distance

    c = msg_str[i]
    while i< msg_str.size && valid_url_char?(c) do
      i += 1
      c = msg_str[i]
    end

    url = msg_str[idx..i-1]
    links << Link.new(url) if url
    i
  end

  def letter?(c)
    c =~ /[A-Za-z]/
  end

  def numeric?(c)
    c =~ /[0-9]/
  end

  def alphanumeric?(c)
    letter?(c) || numeric?(c)
  end

  def valid_url_char?(c)
    alphanumeric?(c) || c =~ /[\.\?\&=\/]/
  end
end
