class UsersController < ApplicationController
  before_action :logged_in? ,only: [:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def show
    @users = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @user = User.all #あとで変更
  end
  
  def create
    @user = User.new(user_params)
    respond_to do |wants|
      if @user.save
        
        # ログインする
        login_session(@user)
        login_cookies(@user)
        
        flash[:notice] = 'User was successfully created.'
        wants.html { redirect_to(@user) }
        wants.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:notice] = "ユーザー作成できません"
        wants.html { render :action => "new" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  
    respond_to do |wants|
      wants.html { redirect_to(users_url) }
      wants.xml  { head :ok }
    end
  end
  
  private
    def user_params
       params.require(:user).permit(:name, :email, :password)
    end
end
