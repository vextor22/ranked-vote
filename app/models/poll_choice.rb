class PollChoice < ApplicationRecord
  belongs_to :poll
  has_many :voter_choices, dependent: :destroy

  validates :name, presence: true
end