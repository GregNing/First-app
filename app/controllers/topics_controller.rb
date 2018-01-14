class TopicsController < ApplicationController
    before_action :set_topic, only: [:show, :update]
def index
    @topics = Topic.all
end

    def show
    end

# GET /topics/new
def new
@topic = Topic.new
end

# GET /topics/1/edit
def edit
end

def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
    if @topic.save
        format.html { redirect_to topics_path, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
    else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
    end
    end
end

def update
    @topic = Topic.new(topic_params)

    respond_to do |format|
    if @topic.update(topics_params)
        format.html { redirect_to topics_path, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
    else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
    end
    end
end

    def upvote
        @topic = Topic.find(params[:id])
        @topic.votes.create
        redirect_to(topics_path)
    end

    def devote
        @topic = Topic.find(params[:id])
        @topic.votes.first.destroy
        redirect_to(topics_path)
    end
private
    def set_topic
        @topic = Topic.find(params[:id])
    end

    def topic_params
    params.require(:topic).permit(:title, :description)
    end
end
