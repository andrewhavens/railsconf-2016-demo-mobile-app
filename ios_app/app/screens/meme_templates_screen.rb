class MemeTemplatesScreen < PM::TableScreen
  title "Meme Templates"
  stylesheet MemeTemplatesScreenStylesheet

  def on_load
    @templates = []
    load_meme_templates
  end

  def load_meme_templates
    MemeTemplate.all do |response, templates|
      if response.success?
        @templates = templates
        update_table_data
      else
        app.alert "Sorry, there was an error fetching the templates."
        mp response.error.localizedDescription
      end
    end
  end

  def table_data
    [{
      cells: @templates.map do |template|
        {
          height: 100,
          title: template.name,
          remote_image: {
            url: template.image_url,
          },
          action: :new_meme,
          arguments: { template: template }
        }
      end
    }]
  end

  def new_meme(args)
    open NewMemeScreen.new(args)
  end

  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end
