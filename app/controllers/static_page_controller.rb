class StaticPageController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.feed.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about

  end

  def contact

  end
end
