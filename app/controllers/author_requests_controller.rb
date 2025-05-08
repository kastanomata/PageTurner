class AuthorRequestsController < ActionController::Base
  before_action :set_user, only: [ :accept, :deny ]

  def index
    @users = User.where.not(author_request: [ nil, "" ]).order(created_at: :desc)
  end

  def accept
    author = Author.find_or_initialize_by(openlibrary_id: @user.author_request)

    if author.new_record?
      author_details = BookApiService.fetch_author_details(@user.author_request)
      author.assign_attributes(
        name: author_details[:name],
        account_id: @user.id
      )
    else
      author.account_id = @user.id
    end

    if author.save
      @user.update(author_request: nil)
      redirect_to reports_path, notice: "Author request accepted"
    else
      redirect_to reports_path, alert: "Failed to accept request: #{author.errors.full_messages.join(', ')}"
    end
  end

  def deny
    if @user.update(author_request: nil)
      redirect_to reports_path, notice: "Author request denied"
    else
      redirect_to reports_path, alert: "Failed to deny request"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
