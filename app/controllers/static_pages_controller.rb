class StaticPagesController < ApplicationController
  def home
    
    if current_user
      @user = current_user
      @posts = current_user.feed.page(params[:page]).per(6)
    else
      
    end
  end

  def about
  end

  def hepl
  end

  def agreement
  end

  def policy
  end

  def corporate
  end
end
