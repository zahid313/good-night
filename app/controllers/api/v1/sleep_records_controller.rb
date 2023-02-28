module Api
    module V1
      class SleepRecordsController < Api::V1::BaseController
        include  Pagination
        before_action :set_sleep_record, only: [:update]
  
        def index
            @q = current_user.sleep_records.ransack(params[:q])
            @sleep_records = @q.result.order("id desc").page(params[:page])
            @pagination  = paginate(@sleep_records)
        end
  
        def create
            @sleep_record = current_user.sleep_records.build(sleep_record_params)
            @sleep_record.save!
            render 'show', status: :created
        end
  
        def update
            @sleep_record.update!(sleep_record_params)
            render 'show'
        end
  
        private
  
        def set_sleep_record
            @sleep_record = current_user.sleep_records.find(params[:id])
        end
  
        def sleep_record_params
            params.require(:sleep_record).permit(:start_time, :end_time)
        end
      end
    end
  end
  