class UsersController < ApplicationController
  before_action :logged_in? ,only: [:show, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def show
    @users = User.find(params[:id])
  end

  def edit
    @users = User.find(params[:id])
    # @status = @users.status
  end

  def index
    @user = User.all #あとで変更
  end
  
  def create
    @user = User.new(user_params)
    respond_to do |wants|
      if @user.save
        
        # アカウント有効メール送信
        @user.create_activation_digest
        UserMailer.activation(@user).deliver_now
        @user.create_status
        
        flash[:notice] = "メールを送信しました #{ edit_activation_url(@user.activation_token, email: @user.email)}"
        wants.html { redirect_to(root_path) }
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
  
  def update
    @users = User.find(params[:id])
    
    respond_to do |wants|
      if @users.update_attributes(user_params) && @users.status.update_attributes(status_params)
        flash[:notice] = "編集しました　#{ params[:user] } ステータス#{ params[:status]}"
        wants.html { redirect_to(@users) }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
    def user_params
       params.require(:user).permit(:name, :email, :password)
    end
    
    def status_params
       params.require(:status).permit(:address, :link, :barthday)
    end
    
     # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
