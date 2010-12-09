require_dependency 'application_controller'
require File.dirname(__FILE__) + '/lib/url_additions'
include UrlAdditions

class PaperclippedExtension < Radiant::Extension
  version "0.8.0"
  description "Assets extension based on the lightweight Paperclip plugin."
  url "http://github.com/krug/paperclipped"
  
  def activate
    
    Radiant::AdminUI.send :include, AssetsAdminUI unless defined? admin.asset # UI is a singleton and already loaded
    admin.asset = Radiant::AdminUI.load_default_asset_regions
    
    Admin::PagesController.class_eval {
      helper Admin::AssetsHelper
    }

    admin.page.edit.add :part_controls, '/admin/assets/show_bucket_link'   
    admin.layout.edit.add :part_controls, '/admin/assets/show_bucket_link'
    admin.snippet.edit.add :part_controls, '/admin/assets/show_bucket_link'
    admin.styles.edit.add :part_controls, '/admin/assets/show_bucket_link'
    admin.scripts.edit.add :part_controls, '/admin/assets/show_bucket_link'

    %w{page layout snippet styles scripts}.each do |view|
      admin.send(view).edit.add :main, "/admin/assets/assets_bucket", :after => "edit_buttons"
      admin.send(view).edit.asset_tabs.concat %w{upload_tab search_tab}
      admin.send(view).edit.asset_panes.concat %w{upload search}
    end

    Page.class_eval do
      include AssetTags
    end

    # connect UserActionObserver with my models 
    UserActionObserver.instance.send :add_observer!, Asset 
    
    # This is just needed for testing if you are using mod_rails
    if Radiant::Config.table_exists? && Radiant::Config["assets.image_magick_path"]
      Paperclip.options[:image_magick_path] = Radiant::Config["assets.image_magick_path"]
    end
    
    tab 'Content' do
      add_item "Assets", "/admin/assets", :after => "Pages"
    end
  end
  
  def deactivate
    
  end
  
end
