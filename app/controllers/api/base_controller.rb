class Api::BaseController < ApplicationController

  def bad_request
    render nothing: true, status: 400
  end
end