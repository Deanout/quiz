class QuizSubmissionsController < ApplicationController
  before_action :find_quiz_submission, only: %i[show]

  def show
    @quiz = @quiz_submission.quiz
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])

    user_answers = {}
    correct_answers = 0

    params.each do |key, value|
      next unless key.start_with?('question_')

      question_id = key.split('_').last.to_i
      selected_answer = value.to_i
      user_answers[question_id.to_s] = selected_answer
      question = Question.find(question_id)

      correct_answers += 1 if question.correct_answer == selected_answer
    end

    score = (correct_answers.to_f / @quiz.questions.count) * 100
    @quiz_submission = QuizSubmission.create(quiz: @quiz, user: current_user, score:, user_answers:)

    redirect_to quiz_submission_path(@quiz, @quiz_submission)
  end

  private

  def find_quiz_submission
    @quiz_submission = QuizSubmission.find(params[:id])
  end

  def quiz_submission_params
    params.require(:quiz_submission).permit(:quiz_id, :user_id, :score, user_answers: {})
  end
end
