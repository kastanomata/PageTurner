module EventsHelper
  def body_class
    classes = []
    classes << "#{controller_name}-#{action_name}"  # e.g. "books-index"
    # classes << "#{controller_name}-controller"      # e.g. "books-controller"
    classes.join(" ")
  end
end
