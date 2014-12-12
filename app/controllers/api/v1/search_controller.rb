class Api::V1::SearchController < Api::V1::BaseController
  rescue_from ActionController::ParameterMissing, with: :bad_request

  def index
    search = Search.new(search_params)

    @results = search.results
  end

  private
    def search_params
      params.require(:query)
    end
end