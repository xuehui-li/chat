class Api::V1::MessagesController < ApplicationController
  respond_to :json

  def parse
    msg_str = params[:message]
    if (msg_str = msg_str = params[:message]).nil?
      render json: {error: 'message param must be present.'}, status: 400
      return
    end

    msg_obj = Message.new(msg_str)
    render json: msg_obj
  end
end
