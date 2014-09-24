ActiveAdmin.register Article do

  # Allow translations parameters
  permit_params translations_attributes: [:id, :locale, :title, :body, :_destroy]

  index do
    id_column
    column :title
    translation_status
    translation_status_flags
    actions
  end

  show do
    attributes_table do
      translated_row(:title)
      translated_row(:italian_title, locale: :it, field: :title)
      translated_row(:body, inline: false)
    end
  end

  form do |f|

    f.inputs 'Article details' do
      f.translated_inputs do |t|
        t.input :title
        t.input :body
      end
    end

    f.actions
  end

end
