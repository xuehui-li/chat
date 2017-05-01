Chat::Application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/messages' => 'messages#parse'
    end
  end
end
