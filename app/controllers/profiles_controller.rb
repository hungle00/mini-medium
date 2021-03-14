class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @user = User.friendly.find(params[:id])
    #@user = User.find_by(username: params[:username])
    #@followers_count = @user.followers.count
    #@followeds_count = @user.followeds.count
  end

  def following
    @title = "Following"
    #@user = User.find_by(username: params[:username])
    @user = User.friendly.find(params[:id])
    @users = @user.followeds
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    #@user = User.find_by(username: params[:username])
    @user = User.friendly.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end
end