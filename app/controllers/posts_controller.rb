class PostsController < ApplicationController
    before_action :find_post_id, :only => [:edit, :update, :destroy]
    before_action :authenticate_user!, :only => [:new , :create, :edit, :update, :destroy]
    def new
        @group = Group.find(params[:group_id])        
        @post = Post.new
    end

    def create
        @group = Group.find(params[:group_id])
        @post = Post.new(post_params)
        @post.group = @group
        @post.user = current_user
        if @post.save
            redirect_to group_path(@group)
        else
            render :new
        end
    end

    def edit
        
    end

    def update
        
        if @posts.update(post_params)            
            redirect_to account_posts_path, notice: "#{@posts.group.title}更新成功"
        else
            render :edit
        end
    end

    def destroy        
        @posts.destroy        
        redirect_to account_posts_path, alert: "#{@posts.content}刪除成功"
        
    end

    private
    def find_post_id
        @posts = Post.find(params[:id])

        if current_user != @posts.user                  
            redirect_to root_path, alert: "You have no permission."
        end
    end

    def post_params
        params.require(:post).permit(:content)        
    end
end
