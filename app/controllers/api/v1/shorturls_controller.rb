module Api
  module V1
    class ShorturlsController < ApplicationController
      def index
        records = Shorturl.page params[:page]
        total_records = Shorturl.count
        render json: {
          records: records,
          total: total_records,
          current_page: records.current_page,
          next_page: records.next_page,
          prev_page: records.prev_page,
          total_pages: records.total_pages
        }, status: 200
      end

      def create
        result = ShorturlsService.create_short_url(params[:original_url])
        if result
          render json: {
            message: "url was shortened",
            original_url: result[:original_url],
            short_url: result[:short_url]
            }, status: :created
        end

      rescue ActiveRecord::RecordInvalid => e
        render json: {message: e}, status: :unprocessable_entity
      end

      def show
        result = ShorturlsService.return_url(params[:url])
        if !result[:status]
          render json: {error: result[:message]}, status: 404
        else
          render json: result[:url], status: 200
        end
      end
    end
  end
end
