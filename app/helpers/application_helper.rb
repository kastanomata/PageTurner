module ApplicationHelper

  #navbar search form
  def render_search_form
    content_tag :div, class: "search-form-wrapper" do
      form_tag(search_path, method: :get, class: "search-form") do
        safe_join([
          text_field_tag(:query, params[:query], placeholder: "Cerca...", class: "search-input"),
          submit_tag("Cerca", class: "search-button")
        ])
      end
    end
  end

end
