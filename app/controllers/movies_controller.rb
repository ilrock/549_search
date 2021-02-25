class MoviesController < ApplicationController
  def index
    if params[:star_rating]
      @movies = Movie.where('start_rating > ?', params[:star_rating])
    elsif params[:query].present?
      # LIKE
      # ILIKE -> Case insensitive
      # ?
      # sql_query = " \
      #   movies.title ILIKE :query \
      #   OR movies.synopsis ILIKE :query \
      #   OR directors.first_name ILIKE :query \
      #   OR directors.last_name ILIKE :query \
      # "

      # full-text search
      # sql_query = " \
      #   movies.title @@ :query \
      #   OR movies.synopsis @@ :query \
      #   OR directors.first_name @@ :query \
      #   OR directors.last_name @@ :query \
      # "

      # @movies = Movie.search_by_movie_and_director(params[:query])
      @movies = PgSearch.multisearch(params[:query]).to_a.sort_by{|pgdoc| pgdoc.searchable_type}.map{|pgdoc| pgdoc.searchable}
    else
      @movies = Movie.all
    end
  end
end
