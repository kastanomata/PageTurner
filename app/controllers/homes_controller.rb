class HomesController < ApplicationController
  allow_unauthenticated_access only: %i[index]

  def index
    @post = Post.new
    @posts = Post.order(created_at: :desc)
  end
end
