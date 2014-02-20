# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    @all_ratings = Movie.pluck(:rating).uniq  #Get all ratings

    session[:ratings] ||= @all_ratings        #Default to all ratings

    if params.has_key? 'commit' and !params.has_key? 'ratings' #This is the case where all ratings are unclicked
      params['ratings'] = @all_ratings
    end

    if params.has_key? 'ratings'              #If params is set, then use that.
      session[:ratings] = params[:ratings]
    end

    #Actually call the database
    @movies = Movie.where(:rating => session[:ratings])

    #Sort movies if there is desire to be sorted
    session[:sort] ||= 'title'                #Default to sort by title
    
    if params.has_key? :sort
      session[:sort] = params[:sort]
    end

    #Sort the Movies object
    @movies = @movies.order(session[:sort])

    #We want to see it too:
    instance_variable_set("@#{session[:sort]}_header", "hilite")

  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end

