module Sortabl
  module ActiveRecordExtensions
    module Sortabl

      extend ActiveSupport::Concern

      module ClassMethods

        def sortabl parameter, *args

          # Init
          unless args.empty?
            default = args[0][:default]
            only = args[0][:only]
            except = args[0][:except]
          end

          raise ArgumentError.new("Do not use 'only' and 'except' together!") if only.present? and except.present?

          # Set default order attribute
          # default:
          order_by_default = default.present? ? default : self.primary_key

          # Extract column name and direction from parameter
          if parameter.present?
            column_name = parameter.to_s.gsub(/(_asc$|_desc$)/, '')
            direction = parameter.to_s.gsub(/^((?!desc$|asc$).)*/, '')

            # Sort by default if column_name is not included in only or column_name is included in except
            return order((order_by_default)) if only.present? and !only.include? column_name.to_sym
            return order((order_by_default)) if except.present? and except.include? column_name.to_sym
          end

          # Convert param_value to symbol
          sort_column = { column_name.to_sym => direction.to_sym } if column_name.present? and direction.present?

          # Order class object
          order((sort_column or order_by_default))
        end

      end

    end
  end
end
