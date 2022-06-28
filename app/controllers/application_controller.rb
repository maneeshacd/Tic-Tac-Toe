class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def forbidden_access
    render_error_state 'Access forbidden', :forbidden
  end

  def record_not_found
    render_error_state 'Not found', :not_found
  end

  def render_error_state(err_msg, status)
    render json: { error: err_msg }, status: status
  end

  def render_success_json(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end
end
