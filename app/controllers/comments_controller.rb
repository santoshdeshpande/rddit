class CommentsController < ApplicationController
	before_filter :authenticate_user!, except: [:index, :show]

	def create
		@link = Link.find_by_id(params[:link_id])
		if @link.nil?
			flash[:notice] = "Could not find link"
			redirect_to :links and return
		end

		@comment = @link.comments.new(comment_params)
		@comment.user = current_user
		respond_to do | format |
			if @comment.save
				format.html {redirect_to @link, notice: 'Comment created successfully'}
				format.json {render json:@comment, status: :created, location: @comment}
			else
				format.html { redirect_to @link, notice: 'Comment could not be created' }
      			format.json { render json: @comment.errors, status: :unprocessable_entity}
			end
		end		
	end


	private
	def comment_params
		params.require(:comment).permit(:body)
	end
end
