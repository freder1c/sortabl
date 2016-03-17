module Sortabl
	module ActiveRecordExtensions
		module Sortabl

			extend ActiveSupport::Concern

			# class Base
			module ClassMethods

				def sortabl *args
					# Init
					default = args[0][:default].to_s if args
					only = args[0][:only]
					except = args[0][:except]
					sort_params = {}

					raise "Invalid Parameters: Do not use 'only' and 'except' together!" if only.present? and except.present?

					# Set default order attribute
					# default:
					#
					order_by_default = default.present? ? default : self.primary_key

					case true
						# List only attributes
						# only:
						#
						when only.present?
							(only.map(&:to_s)).each do |attribute|
								sort_params[attribute + '_asc'] = "#{attribute} asc"
								sort_params[attribute + '_desc'] = "#{attribute} desc"
							end

						# List class attributes without excepts
						# except:
						#
						when except.present?
							(self.column_names - except.map(&:to_s)).each do |attribute|
								sort_params[attribute + '_asc'] = "#{attribute} asc"
								sort_params[attribute + '_desc'] = "#{attribute} desc"
							end

						# List class attribtues
						#
						else
							self.column_names.each do |attribute|
								sort_params[attribute + '_asc'] = "#{attribute} asc"
								sort_params[attribute + '_desc'] = "#{attribute} desc"
							end
					end

					# Order class object
					order((sort_params[args[0][:sort_by]] or "#{order_by_default} asc"))
				end

			end

		end
	end
end
