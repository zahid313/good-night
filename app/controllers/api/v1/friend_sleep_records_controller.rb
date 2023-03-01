module Api
    module V1
      class FriendSleepRecordsController < Api::V1::BaseController
        include  Pagination
        
        def sleep_records
          @sleep_records = current_user.friend_sleep_records
          @pagination  = paginate(@sleep_records)   
        end        
      end
    end
end