class MetaTagsController < ApplicationController  
  before_filter :require_admin

  layout 'admin'

  def edit
    @meta_tag = MetaTag.first || MetaTag.new
  end

  def create
    @meta_tag = MetaTag.new meta_tag_params
    @meta_tag.save
    redirect_to edit_meta_tag_path, notice: 'Updated Meta Tags'
  end

  def update
    @meta_tag = MetaTag.find params[:id]
    @meta_tag.update_attributes meta_tag_params
    redirect_to edit_meta_tag_path, notice: 'Updated Meta Tags'
  end

  def meta_tag_params
    params.require(:meta_tag).permit(:text)
  end
end
