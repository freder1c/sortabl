module Sortabl
	module ActionViewExtensions
		module SortablHelper

			# Renders table head
			# Uses fontawesome as default icons
			# <th 'data-sortable': 'attribute_direction'>Name <i class='fa fa-...'></th>
			#
			def sortabl_th name, attribute, *args

				# To provide full path with all given params
				# make a copy of incoming params and override sort_param only
				sort_params = params.except(:sort)

				# Set default sort path
				sort_params[:sort] = "#{attribute}_asc"

				# if there is already a sort param set, invert or remove sort direction
				if params[:sort].present?

					# if sort param match current attribute, change direction
					if attribute.to_s == params[:sort].gsub(/(_asc$|_desc$)/, '')

						sort_direction = params[:sort].gsub(/^((?!desc$|asc$).)*/, '')

						sort_params[:sort] = "#{attribute}_desc" 	if sort_direction == 'asc'
						sort_params[:sort] = nil 									if sort_direction == 'desc'

					end
				end

				# Generate HTML Code
				html = <<-HTML
			    <th id="#{args[0][:id] if args.present?}" class="#{args[0][:class] if args.present?}" #{args[0].map{ |k,v| "#{k}='#{v}'" unless (k.to_s =~ /^data-(.*)$/).nil? }.join(' ') if args.present?}>
			    	<a href='#{url_for(sort_params)}'>#{name}<i class='fa fa-sort#{sort_direction.present? ? "-#{sort_direction}" : ""}'></i></a>
			    </td>
		    HTML

		    html.html_safe
			end

		end
	end
end
