class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    redirect = false

    if params[:sortItem]
        @sorting = params[:sortItem]
    elsif session[:sortItem]
        @sorting = session[:sortItem]
        redirect = true
    end

    if params[:ratings]
        @ratings = params[:ratings]
    elsif session[:ratings]
        @ratings = session[:ratings]
        redirect = true
    else
        @all_ratings.each do |rat|
            (@ratings ||= { })[rat] = 1
        end
        redirect = true
    end

    if redirect
        redirect_to movies_path(:sortItem => @sorting, :ratings => @ratings)
    end

    @movies = Movie.where("rating IN (?) ", @ratings.keys.select { |key| key })
    @movies.order!(@sorting)

    session[:sortItem] = @sorting
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
