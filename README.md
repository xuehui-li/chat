# Chat
## About
1. This is a Ruby on Rails service that supports the following one API that takes a chat message
string as input and returns a JSON object containing information about its contents:
```
POST /api/v1/messages
```

2. It requires a string `message` param which may contain zero or more mentions, emoticons, and/or links
and returns these attributes in a JSON object as the example curl requests show:
	1. Mentions - A mention is a string that starts with an '@' and ends with a non-word character. 
	2. Emoticons - An emoticon is an alphanumeric string, no longer than 15 characters, contained in parenthesis. 
	3. Links - Any URLs contained in the message, along with the page's title if present. Urls are case-insentivie,
	start with http://, https://, and the rest of the url can only be a word letter, digit, dot, question mark, ampersand, equal sign, or a /.

3. Below are some example curl requests from my development environment where the first line is the
request and the second line is the response.
```
curl -X POST  http://localhost:3000/api/v1/messages  --data-urlencode  "messge=Typo"
{"error":"message param must be present."}
```
If the above curl is provided the option `--verbose`, you can tell `< HTTP/1.1 400 Bad Request` being returned.

```
curl -X POST  http://localhost:3000/api/v1/messages  --data-urlencode  "message=Thank you"
{}
```

```
curl -X POST  http://localhost:3000/api/v1/messages  --data-urlencode  "message=hello @chirs nice to meet you"
{"mentions":["chirs"]}
```
```
curl -X POST  http://localhost:3000/api/v1/messages  --data-urlencode  "message=hello @chirs nice to meet you. @john that is great"  
{"mentions":["chirs","john"]}  
```
```
curl -X POST  http://localhost:3000/api/v1/messages  --data-urlencode "message=@bob @john (success) such a cool feature; http://www.nbcolympics.com"
{"mentions":["bob","john"],"emoticons":["success"],"links":[{"url":"http://www.nbcolympics.com","title":"2018 PyeongChang Olympic Games | NBC Olympics"}]}
```
```
curl -X POST  http://localhost:3000/api/v1/messages.json  --data-urlencode "message=@bob @john (success) such a cool feature; https://yahoo.com"
{"mentions":["bob","john"],"emoticons":["success"],"links":[{"url":"https://yahoo.com"}]}
```
## Setup guide
1. Install Ruby.

2. Install rails: `gem install rails`.

3. Clone the repo.

4. `cd` to the repo inside a terrminal.

5. Run `bundle install`.

To start the service, run `bin/rails server` under the repo directory from a terminal.

## What I would like to do if I had more time
1. Add more tests: for example, `link.rb` has no tests.
2. Look into how to get rid of database.yml and SQLite from Gemfile, as the app has no database persistence.
But a Rails app defaults to have a database which defaults to SQLite when you get the app setup with deafult options.
3. Introduce database persistence:
If our database records all the users in the system, then we can validate each mention is a valid one (assuming
a valid mention is for a user).
With database persistence, we can extend our service to support other things: such as authenticating each request
with a user, each message belongs to a user, etc.
4. Add a customized logger so important actions (like an incoming request, how long it takes), warnings, and errors
can be logged to a configurable location with a desired format.
5. Introduce some static code analysis tool to enforce the code quality as part of each build.
Please note #2 and #3 are mutually exclusive.

### Some assumptions:
1. A mention: anything start with an '@' and ends with a non-word character. 
2. Urls are case-insensitivie, start with http://, https://, and the rest of the url can only be a word letter, digit,
dot, question mark, ampersand, equal sign, or a /.

## Some design choices:
1. Why Ruby on Rails?
Because this is what I'm most comfortable with when getting a new service set up instantly and it works for the code exercise.
But I love to know new technologies.

## Other design notes if extending the service:
1. How to authenticate a request? 
2. Data modeling:
An emoticon typically has other attributes such as an image url. We can have a model to represent emoticons.
