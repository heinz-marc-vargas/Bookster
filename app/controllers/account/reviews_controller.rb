class Account::ReviewsController < ApplicationController
  layout 'reviews'
  before_filter :load_company

  def index
    @reviews = current_user.review_list
    render :layout => false
  end
  
  def view
    @review = Review.find(params[:id])
    render :layout => false
  end
  
  def destroy
    raise "here"
  end
  
  def approve
    @review = Review.find(params[:id])
    @review.update_attribute(:approved, true)
    render :layout => false
  end

  
  def new
    @review_link = ReviewLink.find_by_token(params[:token]) rescue nil        
  end
  
  def create
    @error = nil
    @review_link = ReviewLink.find_by_token(params[:token]) rescue nil
    
    begin
      if @review_link.used?
        raise "You already have submitted a review before."    
      end
      
      unless @review_link.nil?
        @review = Review.new
        @review.staff_id = params[:staff_id] unless params[:staff_id].blank?
        @review.comment = params[:content]
        @review.rating = params[:rating] rescue 0
        @review.branch_id = @review_link.event.branch_id
        @review.customer_id = @review_link.customer_id
        @review.event_id = @review_link.event_id
        
        if @review.save
          @review_link.update_attribute(:used, true)
          Mailer.new_review(@review).deliver
        end
      end
      
    rescue Exception => e
      @error = e.message.to_s
    end
  end

end
