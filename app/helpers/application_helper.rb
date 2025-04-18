module ApplicationHelper

    #navbar search form
    def render_search_form
        content_tag :div do
          form_tag(search_path, method: :get) do
            safe_join([
              text_field_tag(:query, params[:query], placeholder: "Cerca..."),
              submit_tag("Cerca")
            ])
          end
        end
      end

end
