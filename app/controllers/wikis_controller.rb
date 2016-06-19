class WikisController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_user, except: [:index, :show, :new, :create]

  def index
    @wikis = Wiki.where(user: current_user)
  end

  def show
    @wiki = Wiki.find(params[:id])
    unless !@wiki.private || current_user
       flash[:alert] = "You must be signed in to view private wikis."
       redirect_to new_user_registration_path
     end
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    if @wiki.save
      flash[:notice] = "Wiki was saved successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "Error creating wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    if @wiki.save
      flash[:notice] = 'Wiki was updated successfully'
      redirect_to @wiki
    else
      flash.now[:alert] = 'There was an error saving the wiki. Please try again later.'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    if @wiki.destroy
      flash[:notice] = "Wiki deleted successfully"
      redirect_to wikis_index_path
    else
      flash.now[:alert] = "There was an error deleting this wiki. Please try again later."
      redirect_to wikis_index_path
    end
  end


  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

  def authorize_user
    wiki = Wiki.find(params[:id])
    unless current_user == wiki.user
      flash[:alert] = "You must own this wiki to do that."
      redirect_to wiki
    end
  end

end
