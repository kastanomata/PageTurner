class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(id: params[:id])
    @books = @tag.books if @tag
  end
end
