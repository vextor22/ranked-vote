class Voter < ApplicationRecord
  belongs_to :poll
  has_many :voter_choices, dependent: :destroy
end
