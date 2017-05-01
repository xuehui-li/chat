shared_context 'complicated_message', complicated_message: true do
  let(:msg_str) do
    "@#{mention_1} you around? @#{mention_2} bought cookies (#{emoticon_1}) for us: #{url_1} " \
     "(#{emoticon_2}) this place has the best cookies: #{url_2} (notthefirsttimethisplacewins) "
  end
  let(:mention_1) { 'chris' }
  let(:mention_2) { 'john' }
  let(:both_mentions) { [mention_1, mention_2] }
  let(:emoticon_1) { 'cookie' }
  let(:emoticon_2) { 'yummy' }
  let(:both_emoticons) { [emoticon_1, emoticon_2] }
  let(:url_1) { 'https://www.laurascookies.com' }
  let(:url_2) { 'http://www.sfchronicle.com/deserts/bestcookies/' }
  let(:both_urls) { [url_1, url_2] }
  let(:title_2) { 'San Francisco\'s best' }

  before do
    stub_get_request_without_title(url_1)
    stub_get_request_with_title(url_2, title_2)
  end

  def stub_get_request_with_title(url, title)
    stub_get_request(url, "foo<title>#{title}</title>bar")
  end

  def stub_get_request_without_title(url)
    stub_get_request(url, 'Hello')
  end

  def stub_get_request(url, body)
    stub_request(:get, url).to_return(status: 200, body: body)
  end
end
