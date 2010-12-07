class Admin::AssetsController < Admin::ResourceController
  paginate_models
  skip_before_filter :verify_authenticity_token, :only => :create

  def index
    @assets = Asset.search(params[:search], params[:filter], params[:p])
    @source = params[:source]

    respond_to do |format|
      format.html { render }
      format.js {
        @template_name = 'index'
        if @source == "bucket"
          render :partial => 'admin/assets/search_results.html.haml', :layout => false
        else
          render :partial => 'admin/assets/asset_table.html.haml', :locals => { :assets => @assets }, :layout => false
        end
      }
    end
  end

  def create
    @asset = Asset.new(params[:asset])
    if @asset.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Asset successfully uploaded."
          redirect_to(params[:continue] ? edit_admin_asset_path(@asset) : admin_assets_path)
        }
        format.js {
          responds_to_parent do
            render :update do |page|
              page.call('Asset.AddAsset', @asset.asset.url)
              page.call('Asset.ResetForm')
            end
          end
        }
      end
    else
      respond_to do |format|
        format.html {
          render :action => 'new'
        }
        format.js {
          responds_to_parent do
            render :update do |page|
              page.call('Asset.ResetForm')
            end
          end
        }
      end
    end
  end
end
