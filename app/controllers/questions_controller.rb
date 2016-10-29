class QuestionsController < ApplicationController
  include QuestionHelper
  skip_before_action :verify_authenticity_token if Rails.env.test?
  before_action :authenticate_member

  def index
      @questions = Question.all
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @question = Question.new
    @box_title = "Create a question"
    @subtitle  = "Create"
    @placeholder_name = "Title"
    @placeholder_description = "Description"
    @url = topic_questions_path(@topic)
  end

  def show
      @question = Question.find(params[:id])
  end

  def create
    @topic = Topic.find(params[:topic_id])

    @question = Question.new(question_params)
    @question.topic = @topic
    @question.member = current_member

    if @question.save
      send_question @question, 'create_question'
    end
  end

  def edit
  end

  def update
    @question = Question.find(params[:id])

    if @question.update_attributes(question_params)
      send_question @question, 'update_question'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @topic = @question.topic
    @question.destroy
    redirect_to topic_path(@topic)
  end

  private
    def question_params
        params.require(:question).permit(:content, :topic_id, :anonymous)
    end
end
