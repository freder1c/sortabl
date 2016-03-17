module Sortabl
	module ActionViewExtensions
		module SortablHelper

			# Renders table head
			# Uses fontawesome as default icons
			# <th 'data-sortable': 'attribute_direction'>Name <i class='fa fa-...'></th>
			#
			def sortabl_th name, attribute, *args

				# Support custom sort_param
				# If sort_param isn't given, fall back to :sortabl as param
				sort_by = args[0][:sort_param] || :sortabl

				# To provide full path with all given params
				# make a copy of incoming params and override sort_param only
				sort_params = params.except(sort_by)

				# Set default sort path
				sort_params[sort_by] = "#{attribute}_asc"

				# if there is already a sort param set, invert or remove sort direction
				if params[sort_by].present?

					# if sort param match current attribute, change direction
					if attribute.to_s == params[sort_by].gsub(/(_asc$|_desc$)/, '')

						sort_direction = params[sort_by].gsub(/^((?!desc$|asc$).)*/, '')

						sort_params[sort_by] = "#{attribute}_desc" 	if sort_direction == 'asc'
						sort_params[sort_by] = nil 									if sort_direction == 'desc'

					end
				end

				# Get element id and classes
				th_id = args[0][:id] if args.present? and args[0][:id].present?
				th_class = args[0][:class] if args.present? and args[0][:class].present?

				# Generate HTML Code
				html = <<-HTML
			    <th #{"id=#{th_id}" if th_id.present?} class="sortabl#{sort_direction.present? ? " #{sort_direction}" : ""}#{" #{th_class}" if th_class.present?}" #{args[0].map{ |k,v| "#{k}='#{v}'" unless (k.to_s =~ /^data-(.*)$/).nil? }.join(' ') if args.present?}>
			    	<a href='#{url_for(sort_params)}'>#{name}<i class='fa fa-sort#{sort_direction.present? ? "-#{sort_direction}" : ""}'></i></a>
			    </td>
		    HTML

		    html.html_safe
			end

		end
	end
end
