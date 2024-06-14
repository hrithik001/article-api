class Report < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :reason, presence: true
  validates :status, inclusion: { in: %w[pending resolved rejected], message: "%{value} is not a valid status" }
  before_validation :set_default_status, on: :create

  # report a post
  def self.report_post(params, user)
    post = Post.find(params[:post_id])
    report = user.reports.new(post: post, reason: params[:reason])
    
    if report.save
      { message: "Post reported successfully", report: report }
    else
      { error: report.errors.full_messages.to_json }
    end
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
