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
    
    if !session.nil? && ((params[:ratings].nil? && !session[:ratings].nil?) || (params[:sort_by].nil? && !session[:sort_by].nil?))
      params[:ratings] ||= session[:ratings]
      params[:sort_by] ||= session[:sort_by]
      
      params.each{|k,v| session[k]=v}
      
      flash.keep
      redirect_to :action => 'index', :ratings => params[:ratings], :sort_by => params[:sort_by]
    else
      params.each{|k,v| session[k]=v}
    end
      @title_class = "hilite" if params[:sort_by]=="title"
      @release_date_class = "hilite" if params[:sort_by]=="release_date"
    
      @all_ratings = Movie.all_ratings
    
      rate_list = params[:ratings].keys if params[:ratings]
    
      @movies = Movie.filter_by_rate(rate_list)
      @movies = @movies.order(params[:sort_by]) if params[:sort_by]
    
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
