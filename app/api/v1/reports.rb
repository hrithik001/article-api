class Api::V1::Reports < Grape::API
    helpers AuthHelpers

    resources :reports do
        before do
            authenticate!
        end
        desc "Get all reports"
        params do
            optional :query, type: String, desc: "Filter by status"
        end
        get do
            
            if params[:query].present?
                reports = Report.includes(:user, :post).where(status: params[:query])
            else
            reports = Report.includes(:user, :post).all
            end
            present reports, with: Entities::Report
        end

        desc "Get a specific report"
        params do
          requires :id, type: Integer, desc: "ID of the report"
        end
        get ':id' do
          report = Report.find(params[:id])
          present report, with: Entities::Report
        end
        desc "Update the status of a report"
        params do
          requires :id, type: Integer, desc: "ID of the report"
          requires :status, type: String, values: ['pending', 'resolved', 'rejected'], desc: "New status of the report"
        end
        patch ':id/status' do
          report = Report.find(params[:id])
          if report.update(status: params[:status])
                if report.status == 'resolved'

                    post = Post.find_by(id: report.post_id)
                    if post && post.destroy
                        { message: "Report status updated to resolved and post deleted successfully", report: report }
                    else
                        error!("Unable to delete the post", 422)
                    end
                        
                   
                end
                { message: "Status updated successfully to #{report.status}"}
          else
            error!(report.errors.full_messages, 422)
          end
        end
    end
end