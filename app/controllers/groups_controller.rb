class GroupsController < ApplicationController
    before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy, :join , :quit]
    before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
    def index
        @groups = Group.all
    end

    def new
        @group = Group.new
        # @group.save
        # redirect_to groups_path
    end


    def create
    @group = Group.new(group_params)
    #將登入資訊使用者 給予 group.user 再從 view取出使用
    @group.user = current_user
    
    if @group.save
        current_user.join!(@group)
        redirect_to groups_path
    else
        render :new
    end
    end

    def update
        # find_group_and_check_permission

        if @group.update(group_params)
            redirect_to groups_path,notice: "Update Success"
        else
            render :edit
        end
    end

    def show
        @group = Group.find(params[:id])
        @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
    end

    def edit
        # find_group_and_check_permission
        # @group = Group.find(params[:id])

        # if current_user != @group.user
        #     redirect_to root_path, alert: "You have no permission."
        # end
    end
    def destroy
    # find_group_and_check_permission    
    # Post.find_by_group_id(@group).destroy
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
    end

    def join
        @group = Group.find(params[:id])

        if !current_user.is_member_of?(@group)
            current_user.join!(@group)
            flash[:notice] = "加入 #{@group.title} 成功!" 
        else
            flash[:warning] = "你已經是 #{@group.title} 成員了！"
        end
        redirect_to group_path(@group)
    end
    def quit
        @group = Group.find(params[:id])

        if current_user.is_member_of?(@group)
            current_user.quit!(@group)
            flash[:alert] = "已退出 #{@group.title} 成員!"
        else
            flash[:warning] = "你不是 #{@group.title} 成員"
        end        
        redirect_to group_path(@group)
    end
    private
    
    def find_group_and_check_permission
        @group = Group.find(params[:id])
        if current_user != @group.user
            redirect_to root_path, alert: "You have no permission."
        end
    end
    def group_params
        params.require(:group).permit(:title, :description)
    end
end
