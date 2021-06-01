# frozen_string_literal: true

module SnFoil
  class JsonapiSerializerGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :model, type: :string

    class_option :path, desc: 'Base path for file', type: :string, default: 'app/jsonapi_serializers'

    def add_app_file
      raise "Argument[0] \':model\' was not provided" unless model

      file_name = if modules.length.zero?
                    name
                  else
                    "#{modules.join('/')}/#{name}"
                  end

      template('jsonapi_serializer.erb', "#{options[:path]}/#{file_name}_jsonapi_serializer.rb")
    end

    private

    def name
      @name ||= model.split('/').last.underscore.singularize
    end

    def class_name
      @class_name ||= name.camelize
    end

    def modules
      @modules ||= model.split('/')[0..-2].map(&:underscore)
    end

    def class_modules
      return if modules.length.zero?

      @class_modules ||= "#{modules.map(&:camelize).join('::')}::"
    end
  end
end
