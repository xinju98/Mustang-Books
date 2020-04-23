class BooksController < ApplicationController
  def index
    books = Book.all
    respond_to do |format|
      format.html { render :index, locals: { books: books } }
    end
  end
  
  def show
    book = Book.find(params[:id])
    respond_to do |format|
      format.html { render :show, locals: { book: book } }
    end
  end
  
  def new
    book = Book.new
    respond_to do |format|
      format.html { render :new, locals: { book: book } }
    end
  end
  def create
    # new object from params
    book = Book.new(params.require(:book).permit(:title, :author, :price, :genre))
    # respond_to block
    respond_to do |format|
      format.html do
        # if question saves
        if book.save
          # success message
          flash[:success] = "Producted added successfully"
          # redirect to index
          redirect_to books_url
          # else
        else
          # error message
          flash.now[:error] = "Error: Product could not be added"
          # render new
          render :new, locals: { book: book }
        end
      end
    end
  end
  
  def edit
    book = Book.find(params[:id])
    respond_to do |format|
      format.html { render :edit, locals: { book: book } }
    end
  end
  
  def update
    # load existing object again from URL param
    book = Book.find(params[:id])
    # respond_to block
    respond_to do |format|
      format.html do
        # if question updates with permitted params
        if book.update(params.require(:book).permit(:title, :author, :price, :genre))
          # success message
          flash[:success] = 'Product updated successfully'
          # redirect to index
          redirect_to books_url
        # else
        else
          # error message
          flash.now[:error] = 'Error: Product could not be updated'
          # render edit
          render :edit, locals: { book: book }
        end
      end
    end
  end

  def review
    respond_to do |format|
      format.html { render :review, locals: { feedback: {} } }
    end
  end
  
  def leave_feedback
    required = [:name, :email, :reply, :feedback_type, :message]
    form_complete = true
    required.each do |f|
      if params.has_key? f and not params[f].blank?
        # that's good news. do nothing
      else
        form_complete = false
      end
    end
    if form_complete
      form_status_msg = 'Thank you for your feedback!'
    else
      form_status_msg = 'Please fill in all the remaining form fields and resubmit.'
    end
    respond_to do |format|
      format.html { render :review, locals: { status_msg: form_status_msg, feedback: params } }
    end
  end
end
