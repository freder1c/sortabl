require "sortabl/version"
require "sortabl/sortabl_core"
require "sortabl/sortabl_helper"

# Extend ActiveRecord's functionality
ActiveRecord::Base.send :include, Sortabl::ActiveRecordExtensions::Sortabl

# You can do this here or in a Railtie
ActionView::Base.send :include, Sortabl::ActionViewExtensions::SortablHelper
