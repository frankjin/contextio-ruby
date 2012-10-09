class ContextIO
  class API
    # When `include`d into a class, this module provides some helper methods for
    # various things a collections of resources will need or find useful.
    module ResourceCollection
      # (see ContextIO#api)
      attr_reader :api

      # @private
      #
      # For internal use only. Users of this gem shouldn't be calling this
      # directly.
      #
      # @param [API] api A handle on the Context.IO API.
      def initialize(api)
        @api = api
      end

      # Iterates over the resources in question.
      #
      # @example
      #   contextio.connect_tokens.each do |connect_token|
      #     puts connect_token.email
      #   end
      def each(&block)
        result_array = api.request(:get, resource_url)

        result_array.each do |attribute_hash|
          yield resource_class.new(api, attribute_hash)
        end
      end

      private

      # Make sure a ResourceCollection has the declarative syntax handy.
      def self.included(other_mod)
        other_mod.extend(DeclarativeClassSyntax)
      end

      # This module contains helper methods for `API::ResourceCollection`s'
      # class definitions. It gets `extend`ed into a class when
      # `API::ResourceCollection` is `include`d.
      module DeclarativeClassSyntax
        private

        # Declares which class the `ResourceCollection` is intended to wrap. For
        # best results, this should probably be a `Resource`. It defines an
        # accessor for this class on instances of the collection, which is
        # private. Make sure your collection class has required the file with
        # the defeniiton of the class it wraps.
        #
        # @param [Class] klass The class that the collection, well, collects.
        def resource_class(klass)
          define_method(:resource_class) do
            klass
          end
        end

        # Declares the path that this resource collection lives at.
        #
        # @param [String] url The path that refers to this collection of
        #   resources.
        def resource_url(url)
          define_method(:resource_url) do
            url
          end
        end
      end
    end
  end
end
