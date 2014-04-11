require 'htmlcompressor'
require 'nanoc'

module Nanoc
  module Filters
    class MyHtmlCompressor < Nanoc::Filter

      identifier :html_compressor
      type :text

      # Compresses the content with Sprockets::ImageCompressor.
      #
      # @param [String] filename The filename to compress
      # @param [Hash] params Passed through to ImageOptim.new
      # @return [void]
      def run(content, params={})
     		compressor = HtmlCompressor::Compressor.new
  			compressor.compress(content)
      end

    end
  end
end
