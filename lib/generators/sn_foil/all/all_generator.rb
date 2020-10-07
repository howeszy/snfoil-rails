# frozen_string_literal: true

module SnFoil
  class AllGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    argument :model, type: :string

    class_option :type, desc: 'Generate Base or API', type: :string, default: 'base'
    class_option :skip_model, desc: 'Skip Model Creation', type: :boolean, default: false

    def add_model
      raise "Argument[0] \':model\' was not provided" unless model

      generate('model', *call_args, **call_options) unless File.file?("app/models/#{model.singularize.underscore}.rb") || options[:skip_model]
    end

    def add_policy
      generate('sn_foil:policy', *call_args, **call_options)
    end

    def add_searcher
      generate('sn_foil:searcher', *call_args, **call_options)
    end

    def add_context
      generate('sn_foil:context', *call_args, **call_options)
    end

    def add_jsonapi_serializer
      generate('sn_foil:jsonapi_serializer', *call_args, **call_options)
    end

    def add_jsonapi_deserializer
      generate('sn_foil:jsonapi_deserializer', *call_args, **call_options)
    end

    def add_controller
      generate('sn_foil:controller', *call_args, **call_options)
    end

    private

    def call_args
      @call_args ||= [model].concat(args)
    end

    def call_options
      @call_options ||= options.deep_symbolize_keys
    end
  end
end
