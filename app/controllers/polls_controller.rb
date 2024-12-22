class PollsController < ApplicationController
  before_action :set_poll, only: [ :show, :share ]
  def index
    @poll = Poll.new
  end
  def create
    @poll = Poll.new(poll_params)
    if @poll.save
      redirect_to @poll, notice: "Poll was successfully created."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def show
    @poll_choices = @poll.poll_choices
    voters = @poll.voters
    @results = calculate_results

    @winner = calculate_winner(voters)
  end

  def poll_params
    params.require(:poll).permit(:name, poll_choices_attributes: [ :id, :name, :_destroy ])
  end


  def share
    redirect_to new_poll_voter_url(@poll)
  end

  private
  def set_poll
    @poll = Poll.find(params[:id])
  end
  def calculate_results
    # A mock example: Count how many times each choice has been selected by voters
    @poll.poll_choices.includes(:voter_choices).map do
      |choice|
      {
        poll_choice: choice,
        voter_choices: choice.voter_choices
      }
    end
  end

  def calculate_winner(voters)
    @iterations = []
    @iteration_winners = []
    result_choices = @results.dup
    voters_active_rank = voters.each_with_object({}) do |voter, hash|
      hash[voter.id] = 1
    end
    vote_count = result_choices[0][:voter_choices].length
    current_winner = nil

    # Iterate until we have a winner
    while not current_winner or not (current_winner[:vote_count] > vote_count/2) do
      iteration_data = []

      # Count up the current votes
      result_choices.each do |result|
        iteration_data << { choice: result[:poll_choice], vote_count: result[:voter_choices].select {
            |choice|
            choice.rank == voters_active_rank[choice.voter_id]
          }.sum { |vote| 1 }
        }
      end

      # Record the votes
      puts "Iteration: #{iteration_data}"
      @current_winner = iteration_data.max_by { |ir| ir[:vote_count] }
      puts "Winner #{@current_winner}"
      @iteration_winners << @current_winner
      @iterations << iteration_data

      # If we're down to two choices, stop iterating, we're done.
      if result_choices.length == 2
        break
      end

      # Otherwise, pick a loser and remove it, updating any user's vote
      # rank to their next best option
      current_loser = iteration_data.min_by { |ir| ir[:vote_count] }
      puts "Loser #{current_loser}"
      loser_result = result_choices.find { |result| result[:poll_choice].id == current_loser[:choice].id }
      # Remove the loser result from @results
      result_choices.delete_if { |result| result[:poll_choice].id == current_loser[:choice].id }

      loser_result[:voter_choices].each do |choice|
        if choice.rank == voters_active_rank[choice.voter_id]
          next_best_rank = result_choices.map do
            |r|
            r[:voter_choices].find {
              |pc| pc.voter_id == choice.voter_id
            }.rank
          end.compact.min
          voters_active_rank[choice.voter_id] = next_best_rank
        end
      end
      puts "Active ranks: #{voters_active_rank}"




    end
  end
end
