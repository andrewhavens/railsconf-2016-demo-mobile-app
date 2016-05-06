class NewMemeScreen < PM::Screen
  title "New Meme"
  stylesheet NewMemeScreenStylesheet

  attr_accessor :template

  def on_load
    set_nav_bar_button :right, title: "Generate", action: :create_meme
    stylesheet.template = template

    append(UIScrollView, :scroll_view).tap do |sv|
      sv.append(UIView, :container).tap do |c|
        @image_view  = c.append(UIImageView, :meme_image)
        @top_text    = c.append(UITextField, :top_text)
        @bottom_text = c.append(UITextField, :bottom_text)
      end
    end
  end

  def create_meme
    data = {
      top_text: @top_text.data,
      bottom_text: @bottom_text.data,
      meme_template_id: template.id
    }
    Meme.create(data) do |response, meme|
      if response.success?
        open ViewMemeScreen.new(meme: meme)
      else
        app.alert "Sorry, there was an error trying to create your meme: #{response.error.localizedDescription}"
      end
    end
  end

  # You don't have to reapply styles to all UIViews, if you want to optimize, another way to do it
  # is tag the views you need to restyle in your stylesheet, then only reapply the tagged views, like so:
  #   def logo(st)
  #     st.frame = {t: 10, w: 200, h: 96}
  #     st.centered = :horizontal
  #     st.image = image.resource('logo')
  #     st.tag(:reapply_style)
  #   end
  #
  # Then in will_animate_rotate
  #   find(:reapply_style).reapply_styles#

  # Remove the following if you're only using portrait
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
