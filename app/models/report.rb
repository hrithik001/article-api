class Report < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :reason, presence: true
  validates :status, inclusion: { in: %w[pending resolved rejected], message: "%{value} is not a valid status" }
  before_validation :set_default_status, on: :create
  private

  def set_default_status
    self.status ||= 'pending'
  end
end
