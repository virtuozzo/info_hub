class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string   :label
      t.boolean  :active
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string   :application_title
      t.string   :logo
      t.boolean  :disable_logo
      t.string   :favicon
      t.boolean  :disable_favicon
      t.boolean  :powered_by_hide
      t.string   :powered_by_url
      t.string   :powered_by_link_title
      t.string   :powered_by_color
      t.string   :powered_by_text
      t.string   :wrapper_background_color
      t.string   :wrapper_top_background_image
      t.boolean  :disable_wrapper_top_background_image
      t.string   :wrapper_bottom_background_image
      t.boolean  :disable_wrapper_bottom_background_image
      t.string   :body_background_color
      t.string   :body_background_image
      t.boolean  :disable_body_background_image
      t.text     :html_header
      t.text     :html_footer
    end
  end
end
