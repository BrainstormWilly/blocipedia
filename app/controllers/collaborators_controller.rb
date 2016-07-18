class CollaboratorsController < ApplicationController

  before_action :authenticate_user!

  def index
    @wiki = Wiki.find(params[:wiki_id])
    @users = policy_scope(Collaborator)
  end

  def create
    # @wiki = Wiki.find(params[:wiki_id])
    @collab = Collaborator.new(wiki_id: params[:wiki_id], user_id: params[:id])
    authorize @collab
    if @collab.save
      redirect_to :back
    else
      flash[:alert] = "Error creating collaborator. Please try again."
      redirect_to :back
    end
  end

  def destroy
    @collab = Collaborator.where(user_id: params[:id], wiki_id: params[:wiki_id]).first
    authorize @collab
    if @collab.destroy
      redirect_to :back
    else
      flash[:alert] = "There was an error deleting this collaborator. Please try again later."
      redirect_to :back
    end
  end


  private

  def collab_params
    params.require(:collaborator).permit(:user_id, :wiki_id)
  end

end
