class LikesController < ApplicationController
    before_action :set_review

    def create
        current_user.likes.create(review: @review)
      
        respond_to do |format|
          format.turbo_stream do
            if request.referer.present? && request.referer != request.url
              redirect_to request.referer
            else
              redirect_to @review
            end
          end
          format.html do
            if request.referer.present? && request.referer != request.url
              redirect_to request.referer
            else
              redirect_to @review
            end
          end
        end
      end
      
      def destroy
        current_user.likes.find_by(review: @review)&.destroy
      
        respond_to do |format|
          format.turbo_stream do
            if request.referer.present? && request.referer != request.url
              redirect_to request.referer
            else
              redirect_to @review
            end
          end
          format.html do
            if request.referer.present? && request.referer != request.url
              redirect_to request.referer
            else
              redirect_to @review
            end
          end
        end
      end
    private

    def set_review
      @review = Review.find(params[:review_id])
    end
end
