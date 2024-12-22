class VoterChoice < ApplicationRecord
  belongs_to :voter
  belongs_to :poll_choice
  validates :rank, presence: true, numericality: { greater_than: 0 }
end
