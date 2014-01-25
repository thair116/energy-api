class SearchController < ApplicationController
  respond_to :json, :html

  def index
    options = {
      category:       params[:c],
      author:         params[:a],
      published_week: params[:w],
      published_day:  params[:d],
      sort:           params[:s],
      comments:       params[:comments]
    }
    @articles = Article.search(params[:q], options).page(params[:page]).results

    respond_with @articles
  end

end

