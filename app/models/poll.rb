class Poll < ApplicationRecord
  has_many :poll_choices, dependent: :destroy
  has_many :voters, dependent: :destroy

  # Allow creating poll_choices with a poll through a form
  accepts_nested_attributes_for :poll_choices, allow_destroy: true

  validates :name, presence: true

end
