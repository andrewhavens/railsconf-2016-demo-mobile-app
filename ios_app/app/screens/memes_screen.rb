class MemesScreen < PM::TableScreen
  title "Memes"
  stylesheet MemesScreenStylesheet

  refreshable

  def on_load
    @memes = []
    load_memes
  end

  def on_refresh
    load_memes
  end

  def load_memes
    Meme.all do |response, memes|
      if response.success?
        @memes = memes
        stop_refreshing
        update_table_data
      else
        app.alert "Sorry, there was an error fetching the memes."
        mp response.error.localizedDescription
      end
    end
  end

  def table_data
    [{
      cells: @memes.map do |meme|
        {
          height: 100,
          remote_image: {
            url: meme.image_url,
          },
          action: :view_meme,
          arguments: { meme: meme }
        }
      end
    }]
  end

  def view_meme(args)
    open ViewMemeScreen.new(args)
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
