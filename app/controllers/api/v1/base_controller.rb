class Api::V1::BaseController < ApplicationController
    # rescue_from StandardError, with: :server_error
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  
    private
  
    def not_found
        render json: { error: 'Record not found' }, status: :not_found
    end
  
    def bad_request(exception)
        render json: { error: exception.message }, status: :bad_request
    end

    def render_unprocessable_entity(exception)
        render json: { error: exception.record.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end    
  
    def server_error(exception)
        # Log the exception for debugging purposes
        Rails.logger.error exception.message
        Rails.logger.error exception.backtrace.join("\n")
        render json: { error: 'Something went wrong on the server' }, status: :internal_server_error
    end

    def current_user
        User.find(params[:user_id])
    end    

  end
  