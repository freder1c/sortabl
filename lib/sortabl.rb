require "sortabl/version"
require "sortabl/sortabl_core"
require "sortabl/sortabl_helper"

# Extend ActiveRecord's functionality
ActiveRecord::Base.send :include, Sortabl::ActiveRecordExtensions::Sortabl

# Extend ActionViews's functionality
ActionView::Base.send :include, Sortabl::ActionViewExtensions::SortablHelper
