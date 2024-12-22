class VotersController < ApplicationController
  before_action :set_poll, only: [ :new, :create ] # Fix here: Use :new as a symbol

  def new
    @voter = @poll.voters.new
  end

  def create
    @voter = @poll.voters.new(voter_params)

    if @voter.save
      # Save choices
      voter_choices_params.each do |poll_choice_id, rank|
        @voter.voter_choices.create!(
          poll_choice_id: poll_choice_id,
          rank: rank
        )
      end
      redirect_to poll_path(@poll), notice: "Thank you for voting!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_poll
    @poll = Poll.find(params[:poll_id])
  end

  def voter_params
    params.require(:voter).permit(:name)
  end

  def voter_choices_params
    allowed_choice_ids = @poll.poll_choices.pluck(:id)
                              .map(&:to_s)
    choices = params.require(:choices)

    choices.permit(allowed_choice_ids)
  end
end
