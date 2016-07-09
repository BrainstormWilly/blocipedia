class WikisController < ApplicationController

  before_action :authenticate_user!
  # before_action :validate_user
  # before_action :authorize_user, except: [:index, :show, :new, :create]

  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki
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
    authorize @wiki
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    authorize @wiki
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
    authorize @wiki
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


  # def authorize_user
  #   wiki = Wiki.find(params[:id])
  #   unless current_user == wiki.user
  #     flash[:alert] = "You must own this wiki to do that."
  #     redirect_to wiki
  #   end
  # end

end
