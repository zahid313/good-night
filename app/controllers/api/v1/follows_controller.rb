# app/controllers/api/v1/follows_controller.rb

module Api
  module V1
    class FollowsController < Api::V1::BaseController
      before_action :set_user

      def create
        @follow = current_user.active_follows.build(following: @user)
        @follow.save!
        render 'show'
      end

      def destroy
        current_user.active_follows.find_by(following: @user).destroy!
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
