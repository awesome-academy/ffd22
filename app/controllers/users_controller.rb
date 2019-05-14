class UsersController < ApplicationController
  before_action :load_user, only: %i(show destroy)
  before_action :authenticate_user!, only: %i(index show destroy)
  authorize_resource

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show; end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:danger] = t ".delele_failed"
    end
    redirect_to :users
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".load_user.user_not_found"
    redirect_to :root
  end
end
