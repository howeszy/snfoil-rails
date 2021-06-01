# frozen_string_literal: true

module SnFoil
  class SearcherGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :model, type: :string

    class_option :path, desc: 'Base path for file', type: :string, default: 'app/searchers'

    def add_app_file
      raise "Argument[0] \':model\' was not provided" unless model

      file_name = if modules.length.zero?
                    name
                  else
                    "#{modules.join('/')}/#{name}"
                  end

      template('searcher.erb', "#{options[:path]}/#{file_name}_searcher.rb")
    end

    private

    def name
      @name ||= model.split('/').last.underscore.pluralize
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
