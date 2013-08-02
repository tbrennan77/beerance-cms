class MetaTagsController < ApplicationController  
  before_filter :require_admin

  layout 'admin'

  def edit
    @meta_tag = MetaTag.first
  end

  def update
    @meta_tag = MetaTag.find params[:id]
    @meta_tag.update_attributes params[:meta_tag]
    redirect_to edit_meta_tag_path, notice: 'Updated Meta Tags'
  end
end